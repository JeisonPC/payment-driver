require 'sinatra'
require 'sinatra/reloader' if development?
require_relative 'config/database'

require 'dotenv'
Dotenv.load

require 'digest/sha2'


require_relative 'services/api_service'
require_relative 'services/cost_service'
require_relative 'contracts'

require_relative 'models/payment_source'
require_relative 'models/ride'
require_relative 'models/driver'



before do
  headers 'Access-Control-Allow-Origin' => '*'
  headers 'Access-Control-Allow-Methods' => 'POST'
end


# Rutas principales
get '/' do
  'Hole mundo'
end

# Driver
post '/calculate_total_amount' do
  begin
    input = JSON.parse(request.body.read, symbolize_names: true)

    result = CalculateTotalAmountContract.new.call(input)

    if result.success?
      driver_info = result[:driver_info]

      total_amount = CostService.calculate_total_amount(driver_info)
      id = driver_info[:id]

      { total_amount: total_amount, id: id }.to_json
    else
      status 422
      { error: result.errors.to_h }.to_json
    end
  rescue StandardError => e
    status 500
    { error: "Error al procesar la solicitud: #{e.message}" }.to_json
  end
end

# Rider
post '/create_payment_source' do
  begin
    input = JSON.parse(request.body.read, symbolize_names: true)

    result = CreatePaymentSourceContract.new.call(input)

    if result.success?
      tokenized_card_info = result[:tokenized_card_info]

      response = ApiService.make_request('payment_sources', :post, tokenized_card_info, 'private')

      puts "la response"
      puts response.inspect

      if response.key?('error')
        status 500
        { error: 'Error al procesar la solicitud a la API creación de fuente de pago', mensaje: response.error }.to_json
      else
        # Guarda la información del método de pago en la base de datos
        puts "El payment data: #{response}"
        payment_source_data = response['data']['public_data']
        payment_source = PaymentSource.create(
          bin: payment_source_data['bin'],
          last_four: payment_source_data['last_four'],
          exp_month: payment_source_data['exp_month'],
          exp_year: payment_source_data['exp_year'],
          card_holder: payment_source_data['card_holder'],
          validity_ends_at: payment_source_data['validity_ends_at'],
          type: payment_source_data['type'],
          token: response['data']['token'],
          status: response['data']['status'],
          customer_email: response['data']['customer_email'],
          payment_source_id: response['data']['id']
        )
        response.to_json
      end
    else
      status 422
      { error: result.errors.to_h }.to_json
    end
  rescue StandardError => e
    status 500
    { error: "Error al procesar la solicitud: #{e.message}" }.to_json
  end
end

# Viaje solicitado
post '/request_ride' do
  begin
    input = JSON.parse(request.body.read, symbolize_names: true)

    # Validar la entrada utilizando el contrato
    result = RequestRideContract.new.call(input)

    if result.success?
      # Crear el viaje
      ride = Ride.create(start_location: Sequel.function(:ST_GeographyFromText, "POINT(#{input[:latitude]} #{input[:longitude]})"))

      # Asignar un conductor
      driver = Driver.first

      # Asignar el conductor al viaje
      ride.update(driver: driver, status: 'ongoing')

      { status: 'success', ride_id: ride.id }.to_json
    else
      status 422
      { error: result.errors.to_h }.to_json
    end
  rescue StandardError => e
    status 500
    { error: "Error al procesar la solicitud: #{e.message}" }.to_json
  end
end

post '/ride_accomplished' do
  begin
    # Leer y mostrar la entrada
    input = JSON.parse(request.body.read, symbolize_names: true)

    # Validar la entrada
    result = CompleteRideContract.new.call(input)

    unless result.success?
      # Mostrar errores de validación
      puts "Validation errors: #{result.errors.to_h}"
      status 422
      return { error: result.errors.to_h }.to_json
    end

    # Obtener información del conductor
    driver_info = {
      "distance_traveled": input[:distance_traveled],
      "time_elapsed": input[:time_elapsed],
      "id": input[:driver_id]
    }

    # Calcular el monto total a pagar
    total_amount = CostService.calculate_total_amount(driver_info)
    puts "hola total_amount #{total_amount}"

    # Obtener el id del viaje desde la base de datos
    ride = Ride.first(status: 'ongoing', driver_id: input[:driver_id])

    unless ride
      puts "Error: No se encontró un viaje en curso para el conductor con id #{input[:driver_id]}"
      status 404
      return { error: "No se encontró un viaje en curso para el conductor." }.to_json
    end

    puts "Ride ID: #{ride.id}, Distance Traveled: #{input[:distance_traveled]} meters, Time Elapsed: #{input[:time_elapsed]} minutes"

    # Generar una referencia única de pago (puedes personalizar la lógica según tus necesidades)
    reference = generate_payment_reference(ride.id)

    # Generar la firma de integridad
    integrity_signature = generate_integrity_signature(reference, total_amount, "COP", "#{ENV['INTEGRITY_KEY']}")

    # Realizar la transacción usando ApiService después de asegurarse de que el viaje se haya marcado como completado
    transaction_result = ApiService.make_request(
      'transactions',
      :post,
      {
        amount_in_cents: total_amount,
        currency: 'COP',
        signature: integrity_signature,
        customer_email: "jeisonfpovedac@gmail.com",
        payment_method: {
          installments: 2
        },
        reference: reference,
        payment_source_id: 97630
      },
      'private'
    )

    puts "Transaction result: #{transaction_result}"

    if transaction_result.key?('error')
      # Mostrar errores de transacción
      puts "Transaction error: #{transaction_result['error']}"
      status 500
      return { error: 'Error al procesar la transacción', mensaje: transaction_result['error'] }.to_json
    else
      ride.update(
        status: 'completed',
        distance_traveled: input[:distance_traveled],
        time_elapsed: input[:time_elapsed]
      )
      return { status: 'success', total_amount: total_amount, transaction_id: transaction_result['data']['id'] }.to_json
      # Actualizar la información del viaje en la base de datos
      ride.update(
        status: 'completed',
        distance_traveled: input[:distance_traveled],
        time_elapsed: input[:time_elapsed]
      )
    end
  rescue Sequel::NoMatchingRow => e
    # Manejar errores cuando no se encuentra el viaje o el conductor
    puts "Error: #{e.message}"
    status 404
    return { error: "No se encontró el viaje o el conductor." }.to_json
  rescue StandardError => e
    # Manejar errores generales
    puts "Error: #{e.message}"
    status 500
    return { error: "Error al procesar la solicitud: #{e.message}" }.to_json
  end
end

def generate_payment_reference(ride_id)
  "ride_#{ride_id}_#{SecureRandom.hex(4)}"
end



def generate_integrity_signature(reference, amount_in_cents, currency, secret)
  concatenated_string = "#{reference}#{amount_in_cents}#{currency}#{secret}"

  signature = Digest::SHA2.hexdigest(concatenated_string)

  signature
end

require 'sinatra'
require 'sinatra/reloader' if development?
require_relative 'config/database'

require 'dotenv'
Dotenv.load

require_relative 'services/api_service'
require_relative 'services/cost_service'
require_relative 'contracts'

require_relative 'models/payment_source'
require_relative 'models/ride'


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
          customer_email: response['data']['customer_email']
        )

        # Utiliza un código de estado HTTP 200 en lugar de 'success' en la respuesta JSON
        { status: 200, payment_source_id: payment_source.id }.to_json
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

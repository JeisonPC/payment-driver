require 'json'



class DriverController < Sinatra::Controller

  post '/calculate_total_amount' do
    # Supongamos que recibes la información del conductor en el cuerpo de la solicitud
    request_body = JSON.parse(request.body.read, symbolize_names: true)
    driver_info = request_body[:driver_info]

    # Calcula el monto total utilizando el servicio de tarifas
    total_amount = CostService.calculate_total_amount(driver_info)

    # Devuelve el resultado como JSON
    { total_amount: total_amount }.to_json
  end
end

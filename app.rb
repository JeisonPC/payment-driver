require 'sinatra'
require 'sinatra/reloader' if development?
require_relative 'config/database'

require_relative 'services/api_service'
require_relative 'services/cost_service'


# Rutas principales
get '/' do
  'Hole mundo'
end

# Driver
post '/calculate_total_amount' do
  # recibes la información del conductor en el cuerpo de la solicitud
  request_body = JSON.parse(request.body.read, symbolize_names: true)
  driver_info = request_body[:driver_info]

  # Calcula el monto total utilizando el servicio de tarifas
  total_amount = CostService.calculate_total_amount(driver_info)
  id = driver_info[:id]

  # Devuelve el resultado como JSON
  { total_amount: total_amount, id: id }.to_json
end

# Rider

post '/'

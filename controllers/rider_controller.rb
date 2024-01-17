class RiderController < Sinatra::Base
  get '/rider/:id' do
    # lógica para obtener información del pasajero con el ID especificado
  end

  post '/rider/:id/payment_method' do
    # lógica para crear un método de pago para el pasajero
  end

  post '/rider/request_ride' do
    # lógica para solicitar un viaje
  end
end

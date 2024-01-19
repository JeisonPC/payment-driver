# spec/api/calculate_total_amount_spec.rb

require 'spec_helper'
require 'rack/test'
require_relative '../../app'  # Reemplaza con la ubicación real de tu archivo app.rb

RSpec.describe 'Calculate Total Amount API' do
  include Rack::Test::Methods

  def app
    App
  end

  describe 'POST /calculate_total_amount' do
    it 'calculates total amount successfully' do
      # Simula una solicitud POST con datos de entrada
      post '/calculate_total_amount', JSON.generate(your_input_data), 'CONTENT_TYPE' => 'application/json'

      # Verifica que la respuesta tenga un código 200 (éxito)
      expect(last_response.status).to eq(200)

      # Convierte la respuesta JSON en un hash para realizar más verificaciones
      response_data = JSON.parse(last_response.body, symbolize_names: true)

      # Verifica que la respuesta incluya las claves esperadas
      expect(response_data).to include(:total_amount, :id)

      # Puedes realizar más verificaciones según la lógica de tu aplicación
      # Por ejemplo, verificar que el total_amount sea un número positivo, etc.
    end

    it 'handles validation errors' do
      # Simula una solicitud POST con datos de entrada inválidos
      post '/calculate_total_amount', JSON.generate(invalid_input_data), 'CONTENT_TYPE' => 'application/json'

      # Verifica que la respuesta tenga un código 422 (error de validación)
      expect(last_response.status).to eq(422)

      # Puedes realizar más verificaciones según la lógica de tu aplicación
      # Por ejemplo, verificar que la respuesta incluya un mensaje de error específico
    end

    it 'handles internal server errors' do
      # Simula una situación en la que ocurre un error interno en el servidor
      allow(CostService).to receive(:calculate_total_amount).and_raise(StandardError.new('Internal Server Error'))

      # Simula una solicitud POST con datos de entrada
      post '/calculate_total_amount', JSON.generate(your_input_data), 'CONTENT_TYPE' => 'application/json'

      # Verifica que la respuesta tenga un código 500 (error interno del servidor)
      expect(last_response.status).to eq(500)

      # Puedes realizar más verificaciones según la lógica de tu aplicación
      # Por ejemplo, verificar que la respuesta incluya un mensaje de error específico
    end
  end
end

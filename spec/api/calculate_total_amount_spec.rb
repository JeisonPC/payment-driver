require 'spec_helper'
require 'rack/test'
require_relative '../../app'

RSpec.describe "Calculate Total Amount API", type: :request do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe "POST /calculate_total_amount" do
    let(:valid_input_data) do
      {
        "driver_info": {
          "distance_traveled": 50,
          "time_elapsed": 6,
          "id": 11225
        }
      }
    end

    let(:invalid_input_data) do
      # Define datos de entrada no válidos para tus pruebas
    end

    it "calculates total amount successfully" do
      post '/calculate_total_amount', JSON.generate(valid_input_data), 'CONTENT_TYPE' => 'application/json'

      expect(last_response.status).to eq(200)
      response_data = JSON.parse(last_response.body)
      expect(response_data).to include('total_amount', 'id')
      # Agrega más expectativas según tus necesidades
    end

    it "handles validation errors" do
      post '/calculate_total_amount', JSON.generate(invalid_input_data), 'CONTENT_TYPE' => 'application/json'

      expect(last_response.status).to eq(422)
      response_data = JSON.parse(last_response.body)
      expect(response_data).to include('error')
      # Agrega más expectativas según tus necesidades
    end

    it "handles internal server errors" do
      # Si hay algún manejo de errores interno, puedes simular un escenario de error aquí
      allow(CostService).to receive(:calculate_total_amount).and_raise("Simulated error")

      post '/calculate_total_amount', JSON.generate(valid_input_data), 'CONTENT_TYPE' => 'application/json'

      expect(last_response.status).to eq(500)
      response_data = JSON.parse(last_response.body)
      expect(response_data).to include('error')
      # Agrega más expectativas según tus necesidades
    end
  end
end

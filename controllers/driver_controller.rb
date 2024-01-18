require 'json'
require_relative 'wompi_service'

class DriverController < Sinatra::Base

  private

  def calculate_total_amount(driver_info, final_location)

    base_cop = 3500

    # Calcula el monto total según la lógica de tarifas
    total_amount = base_cop + (driver_info[:distance_traveled] * 1000) + (driver_info[:time_elapsed] * 200)

    return total_amount
  end
end

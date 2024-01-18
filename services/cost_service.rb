class TariffService
  COST_BASE = 3500
  COST_KM = 1000
  COST_MINUTE = 200

  def self.calculate_total_amount(driver_info)
    base_amount = BASE_COP
    distance_amount = driver_info[:distance_traveled] * DISTANCE_RATE
    time_amount = driver_info[:time_elapsed] * TIME_RATE

    total_amount = base_amount + distance_amount + time_amount

    total_amount
  end
end

require 'dry-validation'

class CalculateTotalAmountContract < Dry::Validation::Contract
  params do
    required(:driver_info).hash do
      required(:id).filled(:integer)
      required(:distance_traveled).filled(:integer)
      required(:time_elapsed).filled(:integer)
    end
  end
end

class CreatePaymentSourceContract < Dry::Validation::Contract
  params do
    required(:tokenized_card_info).hash do
      required(:type).filled(:string)
      required(:token).filled(:string)
      required(:customer_email).filled(:string)
      required(:acceptance_token).filled(:string)
    end
  end
end

class RequestRideContract < Dry::Validation::Contract
  params do
    required(:latitude).filled(:float)
    required(:longitude).filled(:float)
  end
end

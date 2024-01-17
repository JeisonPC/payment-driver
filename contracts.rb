require 'dry-validation'

class DriverContract < Dry::Validation::Contract
  params do
    required(:nombre).filled(:string)
    required(:apellido).filled(:string)
    required(:edad).filled(:integer, gteq?: 18)
  end
end

class RiderContract < Dry::Validation::Contract
  params do
    required(:nombre).filled(:string)
    required(:apellido).filled(:string)
    required(:edad).filled(:integer, gteq?: 18)
  end
end

class TripContract < Dry::Validation::Contract
  params do
    required(:nombre).filled(:string)
    required(:apellido).filled(:string)
    required(:edad).filled(:integer, gteq?: 18)
  end
end

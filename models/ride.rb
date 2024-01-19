# ride.rb
require 'dry-validation'

class Ride < Sequel::Model
  plugin :timestamps, update_on_create: true

  String :status

  many_to_one :rider
  many_to_one :driver
end

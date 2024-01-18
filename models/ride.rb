require 'dry-validation'
class Trip < Sequel::Model
  set_table_name 'rides'
  attribute :start_location, 'geography(POINT)'
  attribute :status, String
  timestamp :created_at, default: Sequel::CURRENT_TIMESTAMP

  many_to_one :rider
  many_to_one :driver
end

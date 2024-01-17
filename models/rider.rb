require 'dry-validation'

class Rider < Sequel::Model
  # Atributos
  set_table_name 'riders'
  attribute :nombre, String
  attribute :apellido, String
  attribute :email, String
  attribute :current_location, 'geography(POINT)'
  attribute :payment_method, String
  attribute :edad, Integer
end

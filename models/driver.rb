require 'dry-validation'

class Driver < Sequel::Model
  # Atributos
  set_table_name 'drivers'
  attribute :nombre, String
  attribute :apellido, String
  attribute :email, String
  attribute :current_location, 'geography(POINT)'
  attribute :edad, Integer
end

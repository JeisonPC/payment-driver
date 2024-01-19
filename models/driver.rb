# driver.rb
require 'dry-validation'

class Driver < Sequel::Model
  set_primary_key :id
  String :nombre
  String :apellido
  String :email
  column :'geography(POINT)', :current_location, type: 'geography(POINT)'
  Integer :edad

  many_to_many :rides
end

# driver.rb
require 'dry-validation'

class Driver < Sequel::Model
  set_primary_key :id
  String :nombre
  String :apellido
  String :email

  many_to_many :rides
end

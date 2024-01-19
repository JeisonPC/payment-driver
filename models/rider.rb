# rider.rb
require 'dry-validation'
class Rider < Sequel::Model
  set_primary_key :id

  column :nombre, String
  column :apellido, String
  column :email, String
  column :current_location, 'geography(POINT)'

  one_to_many :rides
  one_to_many :payment_sources
end

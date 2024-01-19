# payment_source.rb
require 'sequel'
require 'dry-validation'

class PaymentSource < Sequel::Model
  set_primary_key :id
  String :bin
  String :last_four
  String :exp_month
  String :exp_year
  String :card_holder
  String :validity_ends_at
  String :type
  String :token
  String :status
  String :customer_email
end

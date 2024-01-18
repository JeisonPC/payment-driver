require 'net/http'
require 'uri'
require 'json'

class ApiService
  def self.make_request(endpoint, method, data = nil)
    uri = URI.parse("https://sandbox.wompi.co/v1/#{endpoint}")
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    request = case method.downcase.to_sym
              when :post
                Net::HTTP::Post.new(uri.path)
              else
                raise ArgumentError, "Método no soportado: #{method}"
              end

    request['Authorization'] = 'prv_test_WQDT81dQU9avYonr1tO3nhRGaCcupZNA'
    request['Content-Type'] = 'application/json'
    request.body = data.to_json if data

    response = https.request(request)

    JSON.parse(response.body)
  end
end

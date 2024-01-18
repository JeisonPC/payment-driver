require 'net/http'
require 'uri'
require 'json'

class ApiService
  def self.make_request(endpoint, method, data = nil, type_key)
    uri = URI.parse("https://sandbox.wompi.co/v1/#{endpoint}")
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

  puts "Esta es la data del service:"
  puts data

    request = case method.downcase.to_sym
              when :post
                Net::HTTP::Post.new(uri.path)
              else
                raise ArgumentError, "Método no soportado: #{method}"
              end


              request['Authorization'] = (type_key == 'private') ? "Bearer #{ENV['PRIVATE_KEY']}" : "Bearer #{ENV['PUBLIC_KEY']}"


    request['Content-Type'] = 'application/json'
    request.body = data.to_json if data

    response = https.request(request)

    puts "PRIVATE_KEY: #{ENV['PRIVATE_KEY']}"
    puts "PUBLIC_KEY: #{ENV['PUBLIC_KEY']}"

    JSON.parse(response.body)
  end
end

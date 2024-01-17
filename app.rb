# app.rb
require 'sinatra'
require 'sinatra/reloader' if development?
require_relative 'config/database'

# Cargar controladores
Dir["./controllers/*.rb"].each { |file| require file }

# Rutas principales
get '/' do
  HomeController.index
end

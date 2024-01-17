require 'sequel'

DB = Sequel.connect(adapter: 'postgresql', host: '127.0.0.1',
database: 'postgres', username: 'postgres', password: 'postgres')

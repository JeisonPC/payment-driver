require 'sequel'

desc 'Run migrations'
task :migrate do
  DB = Sequel.connect(adapter: 'postgresql', host: '127.0.0.1',
  database: 'postgres', username: 'postgres', password: 'postgres')  # Conecta a tu base de datos
  Sequel::Migrator.run(DB, "db/migrations")
end

Sequel.migration do
  change do
    create_table(:riders) do
      primary_key :id
      String :nombre
      String :apellido
      String :email
      column :'geography(POINT)', :current_location, type: 'geography(POINT)'
    end
  end
end

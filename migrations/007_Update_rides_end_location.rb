Sequel.migration do
  change do
    alter_table(:rides) do
      add_column :end_location, 'geography(POINT)'
    end
  end
end

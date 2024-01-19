Sequel.migration do
  change do
    alter_table(:rides) do
      add_column :distance_traveled, Float
      add_column :time_elapsed, Integer
    end
  end
end

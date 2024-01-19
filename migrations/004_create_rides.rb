Sequel.migration do
  change do
    create_table(:rides) do
      primary_key :id
      column :start_location, 'geography(POINT)'
      String :status
      timestamp :created_at, default: Sequel::CURRENT_TIMESTAMP

      foreign_key :rider_id, :riders
      foreign_key :driver_id, :drivers
    end
  end
end

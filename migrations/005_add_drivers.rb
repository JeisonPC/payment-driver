Sequel.migration do
  change do
    drivers_new = [
      { nombre: 'Jeison', apellido: 'Chavez', email: 'jeison@col.com', 'geography(POINT)' => Sequel.function(:ST_GeographyFromText, 'POINT(0 0)') },
      { nombre: 'Carlos', apellido: 'Narvaez', email: 'carl@col.com', 'geography(POINT)' => Sequel.function(:ST_GeographyFromText, 'POINT(1 1)') },
    ]

    self[:drivers].multi_insert(drivers_new)
  end
end

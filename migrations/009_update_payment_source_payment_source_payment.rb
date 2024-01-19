Sequel.migration do
  change do
    alter_table(:payment_sources) do
      add_column :payment_source_payment, Integer
    end
  end
end

Sequel.migration do
  change do
    create_table(:notes) do
      primary_key :id
      String :text, null: false
    end
  end
end

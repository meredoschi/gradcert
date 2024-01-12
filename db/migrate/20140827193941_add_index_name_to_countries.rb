class AddIndexNameToCountries < ActiveRecord::Migration[4.2]
  def change
    add_index :countries, :name, unique: true
  end
end

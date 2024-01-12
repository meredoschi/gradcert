class AddAsciinamewithstateToMunicipality < ActiveRecord::Migration[4.2]
  def change
    add_column :municipalities, :asciinamewithstate, :string
    add_index :municipalities, :asciinamewithstate, unique: true
  end
end

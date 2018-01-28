class AddAsciinamewithstateToMunicipality < ActiveRecord::Migration
  def change
    add_column :municipalities, :asciinamewithstate, :string
    add_index :municipalities, :asciinamewithstate, unique: true
  end
end

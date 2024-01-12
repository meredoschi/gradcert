class AddNamewithstateToMunicipality < ActiveRecord::Migration[4.2]
  def change
    add_column :municipalities, :namewithstate, :string
    add_index :municipalities, :namewithstate, unique: true
  end
end

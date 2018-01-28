class AddNamewithstateToMunicipality < ActiveRecord::Migration
  def change
    add_column :municipalities, :namewithstate, :string
    add_index :municipalities, :namewithstate, unique: true
  end
end

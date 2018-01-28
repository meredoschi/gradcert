class CreateMunicipalities < ActiveRecord::Migration
  def change
    create_table :municipalities do |t|
      t.string :name, limit: 50, null: false
      t.integer :stateregion_id
    end
  end
end

class CreateMunicipalities < ActiveRecord::Migration[4.2]
  def change
    create_table :municipalities do |t|
      t.string :name, limit: 50, null: false
      t.integer :stateregion_id
    end
  end
end

class IndexProfessionOnName < ActiveRecord::Migration[4.2]
  def change
    add_index :professions, [:name], unique: true
  end
end

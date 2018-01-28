class IndexProfessionOnName < ActiveRecord::Migration
  def change
    add_index :professions, [:name], unique: true
  end
end

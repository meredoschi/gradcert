class IndexContactOnAddress < ActiveRecord::Migration[4.2]
  def change
    add_index :contacts, [:address_id], unique: true
  end
end

class IndexContactOnAddress < ActiveRecord::Migration
  def change
    add_index :contacts, [:address_id], unique: true
  end
end

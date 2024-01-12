class AddUseridIndexToContacts < ActiveRecord::Migration[4.2]
  def change
    add_index :contacts, :user_id, unique: true
  end
end

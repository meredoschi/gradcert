class ImproveContactIndices < ActiveRecord::Migration[4.2]
  def change
    remove_index :contacts, %i[user_id address_id]
    add_index :contacts, :user_id, unique: true
  end
end

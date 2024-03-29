class FixContactIndices < ActiveRecord::Migration[4.2]
  def change
    remove_index :contacts, column: [:user_id]
    remove_index :contacts, column: [:address_id]

    add_index :contacts, %i[user_id address_id], unique: true
  end
end

class AddNameToContacts < ActiveRecord::Migration[4.2]
  def change
    add_column :contacts, :name, :string, limit: 200, null: false
  end
end

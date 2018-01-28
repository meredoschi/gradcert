class AddNameToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :name, :string, limit: 200, null: false
  end
end

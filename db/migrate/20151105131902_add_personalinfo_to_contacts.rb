class AddPersonalinfoToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :personalinfo_id, :integer
  end
end

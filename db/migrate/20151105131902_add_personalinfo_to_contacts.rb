class AddPersonalinfoToContacts < ActiveRecord::Migration[4.2]
  def change
    add_column :contacts, :personalinfo_id, :integer
  end
end

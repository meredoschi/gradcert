class AddWebinfoIdToContacts < ActiveRecord::Migration[4.2]
  def change
    add_column :contacts, :webinfo_id, :integer
  end
end

class AddWebinfoIdToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :webinfo_id, :integer
  end
end

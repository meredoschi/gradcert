class AddContactidToPersonalinfo < ActiveRecord::Migration[4.2]
  def change
    add_column :personalinfos, :contact_id, :integer
  end
end

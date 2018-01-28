class AddContactidToPersonalinfo < ActiveRecord::Migration
  def change
    add_column :personalinfos, :contact_id, :integer
  end
end

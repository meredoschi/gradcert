class IndexPersonalinfoByContactId < ActiveRecord::Migration
  def change
    add_index :personalinfos, :contact_id, unique: true
  end
end

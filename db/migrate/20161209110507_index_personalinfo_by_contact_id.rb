class IndexPersonalinfoByContactId < ActiveRecord::Migration[4.2]
  def change
    add_index :personalinfos, :contact_id, unique: true
  end
end

class IndexForeignKeysInPersonalinfos < ActiveRecord::Migration
  def change
    add_index :personalinfos, :country_id
    add_index :personalinfos, :state_id
  end
end

class IndexForeignKeysInWebinfos < ActiveRecord::Migration
  def change
    add_index :webinfos, :council_id
    add_index :webinfos, :institution_id
    add_index :webinfos, :regionaloffice_id
  end
end

class IndexForeignKeysInProgramnames < ActiveRecord::Migration
  def change
    add_index :programnames, :ancestor_id
  end
end

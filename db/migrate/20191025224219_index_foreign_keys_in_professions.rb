class IndexForeignKeysInProfessions < ActiveRecord::Migration
  def change
    add_index :professions, :professionalfamily_id
  end
end

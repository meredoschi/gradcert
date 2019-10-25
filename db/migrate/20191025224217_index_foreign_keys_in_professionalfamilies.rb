class IndexForeignKeysInProfessionalfamilies < ActiveRecord::Migration
  def change
    add_index :professionalfamilies, :council_id
    add_index :professionalfamilies, :subgroup_id
  end
end

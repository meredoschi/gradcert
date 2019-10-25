class IndexForeignKeysInAssessments < ActiveRecord::Migration
  def change
    add_index :assessments, :contact_id
    add_index :assessments, :profession_id
  end
end

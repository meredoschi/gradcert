class IndexForeignKeysInDiplomas < ActiveRecord::Migration
  def change
    add_index :diplomas, :council_id
    add_index :diplomas, :coursename_id
    add_index :diplomas, :institution_id
    add_index :diplomas, :profession_id
    add_index :diplomas, :school_id
    add_index :diplomas, :schoolname_id
    add_index :diplomas, :student_id
    add_index :diplomas, :supervisor_id
  end
end

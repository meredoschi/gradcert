class IndexForeignKeysInCourses < ActiveRecord::Migration
  def change
    add_index :courses, :address_id
    add_index :courses, :coursename_id
    add_index :courses, :methodology_id
    add_index :courses, :professionalfamily_id
    add_index :courses, :program_id
    add_index :courses, :supervisor_id
  end
end

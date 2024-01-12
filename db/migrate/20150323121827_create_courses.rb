class CreateCourses < ActiveRecord::Migration[4.2]
  def change
    create_table :courses do |t|
      t.integer :coursename_id
      t.integer :profession_id
      t.boolean :practical, default: false
      t.boolean :core, default: false
      t.boolean :professionalrequirement, default: false
      t.integer :contact_id
      t.integer :methodology_id
      t.integer :address_id
      t.integer :workload
      t.string :syllabus, limit: 4000
      t.timestamps
    end
  end
end

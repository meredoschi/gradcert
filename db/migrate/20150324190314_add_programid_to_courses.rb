class AddProgramidToCourses < ActiveRecord::Migration[4.2]
  def change
    add_column :courses, :program_id, :integer
  end
end

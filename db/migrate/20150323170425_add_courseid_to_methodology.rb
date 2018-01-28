class AddCourseidToMethodology < ActiveRecord::Migration
  def change
    add_column :methodologies, :course_id, :integer
  end
end

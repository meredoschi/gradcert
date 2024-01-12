class AddCourseidToMethodology < ActiveRecord::Migration[4.2]
  def change
    add_column :methodologies, :course_id, :integer
  end
end

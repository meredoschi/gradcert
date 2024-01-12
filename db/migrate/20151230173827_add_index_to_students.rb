class AddIndexToStudents < ActiveRecord::Migration[4.2]
  def change
    add_index :students, :contact_id
  end
end

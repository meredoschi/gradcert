class AddIndexToStudents < ActiveRecord::Migration
  def change
    add_index :students, :contact_id
  end
end

class AddSchoolnameidToDiploma < ActiveRecord::Migration[4.2]
  def change
    add_column :diplomas, :schoolname_id, :integer
  end
end

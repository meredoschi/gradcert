class AddSchoolnameidToDiploma < ActiveRecord::Migration
  def change
    add_column :diplomas, :schoolname_id, :integer
  end
end

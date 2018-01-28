class AddOthercourseToDiploma < ActiveRecord::Migration
  def change
    add_column :diplomas, :othercourse, :string, limit: 100
  end
end

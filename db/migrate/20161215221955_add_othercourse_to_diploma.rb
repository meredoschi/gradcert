class AddOthercourseToDiploma < ActiveRecord::Migration[4.2]
  def change
    add_column :diplomas, :othercourse, :string, limit: 100
  end
end

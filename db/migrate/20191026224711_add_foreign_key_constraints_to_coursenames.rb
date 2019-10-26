class AddForeignKeyConstraintsToCoursenames < ActiveRecord::Migration
  def change
    add_foreign_key :coursenames, :schools
  end
end

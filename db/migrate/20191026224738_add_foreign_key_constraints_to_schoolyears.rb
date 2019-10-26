class AddForeignKeyConstraintsToSchoolyears < ActiveRecord::Migration
  def change
    add_foreign_key :schoolyears, :programs
  end
end

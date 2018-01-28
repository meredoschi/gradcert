class AddFlagsToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :newprog, :boolean, default: false
    add_column :programs, :approved, :boolean, default: false
  end
end

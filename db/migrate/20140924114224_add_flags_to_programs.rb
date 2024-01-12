class AddFlagsToPrograms < ActiveRecord::Migration[4.2]
  def change
    add_column :programs, :newprog, :boolean, default: false
    add_column :programs, :approved, :boolean, default: false
  end
end

class AddForeignKeyConstraintsToBrackets < ActiveRecord::Migration
  def change
    add_foreign_key :brackets, :taxations
  end
end

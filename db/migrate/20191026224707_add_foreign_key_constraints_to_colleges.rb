class AddForeignKeyConstraintsToColleges < ActiveRecord::Migration
  def change
    add_foreign_key :colleges, :institutions
  end
end

class AddForeignKeyConstraintsToSchools < ActiveRecord::Migration
  def change
    add_foreign_key :schools, :academiccategories
  end
end

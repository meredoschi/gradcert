class AddForeignKeyConstraintsToPayrolls < ActiveRecord::Migration
  def change
    add_foreign_key :payrolls, :scholarships
    add_foreign_key :payrolls, :taxations
  end
end

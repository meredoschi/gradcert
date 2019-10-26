class AddForeignKeyConstraintsToFundings < ActiveRecord::Migration
  def change
    add_foreign_key :fundings, :characteristics
  end
end

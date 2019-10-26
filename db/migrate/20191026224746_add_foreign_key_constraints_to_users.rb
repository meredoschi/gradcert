class AddForeignKeyConstraintsToUsers < ActiveRecord::Migration
  def change
    add_foreign_key :users, :institutions
    add_foreign_key :users, :permissions
  end
end

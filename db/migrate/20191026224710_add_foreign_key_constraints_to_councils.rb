class AddForeignKeyConstraintsToCouncils < ActiveRecord::Migration
  def change
    add_foreign_key :councils, :addresses
    add_foreign_key :councils, :phones
    add_foreign_key :councils, :states
    add_foreign_key :councils, :webinfos
  end
end

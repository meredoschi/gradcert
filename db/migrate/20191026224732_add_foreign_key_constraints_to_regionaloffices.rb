class AddForeignKeyConstraintsToRegionaloffices < ActiveRecord::Migration
  def change
    add_foreign_key :regionaloffices, :addresses
    add_foreign_key :regionaloffices, :phones
    add_foreign_key :regionaloffices, :webinfos
  end
end

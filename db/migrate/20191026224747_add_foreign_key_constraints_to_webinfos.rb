class AddForeignKeyConstraintsToWebinfos < ActiveRecord::Migration
  def change
    add_foreign_key :webinfos, :contacts
    add_foreign_key :webinfos, :councils
    add_foreign_key :webinfos, :institutions
    add_foreign_key :webinfos, :regionaloffices
  end
end

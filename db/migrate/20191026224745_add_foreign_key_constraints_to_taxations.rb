class AddForeignKeyConstraintsToTaxations < ActiveRecord::Migration
  def change
    add_foreign_key :taxations, :brackets
  end
end

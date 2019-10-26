class AddForeignKeyConstraintsToStatements < ActiveRecord::Migration
  def change
    add_foreign_key :statements, :bankpayments
    add_foreign_key :statements, :registrations
  end
end

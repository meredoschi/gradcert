class AddForeignKeyConstraintsToBankpayments < ActiveRecord::Migration
  def change
    add_foreign_key :bankpayments, :payrolls
  end
end

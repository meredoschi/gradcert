class FixStatementIndex < ActiveRecord::Migration
  def change
    remove_index :statements, column: %i[bankpayment_id registration_id]
    add_index :statements, %i[registration_id bankpayment_id], unique: true
  end
end

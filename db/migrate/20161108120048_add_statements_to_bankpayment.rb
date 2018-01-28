class AddStatementsToBankpayment < ActiveRecord::Migration
  def change
    add_column :bankpayments, :statements, :boolean, default: false
  end
end

class AddStatementsToBankpayment < ActiveRecord::Migration[4.2]
  def change
    add_column :bankpayments, :statements, :boolean, default: false
  end
end

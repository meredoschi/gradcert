class AddSequentialToBankpayments < ActiveRecord::Migration
  def change
    add_column :bankpayments, :sequential, :integer
  end
end

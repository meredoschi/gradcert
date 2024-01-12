class AddSequentialToBankpayments < ActiveRecord::Migration[4.2]
  def change
    add_column :bankpayments, :sequential, :integer
  end
end

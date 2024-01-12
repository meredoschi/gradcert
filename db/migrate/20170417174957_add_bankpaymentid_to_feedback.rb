class AddBankpaymentidToFeedback < ActiveRecord::Migration[4.2]
  def change
    add_column :feedbacks, :bankpayment_id, :integer
  end
end

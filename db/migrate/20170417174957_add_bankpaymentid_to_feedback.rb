class AddBankpaymentidToFeedback < ActiveRecord::Migration
  def change
    add_column :feedbacks, :bankpayment_id, :integer
  end
end

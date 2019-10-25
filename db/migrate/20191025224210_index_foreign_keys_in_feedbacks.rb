class IndexForeignKeysInFeedbacks < ActiveRecord::Migration
  def change
    add_index :feedbacks, :bankpayment_id
    add_index :feedbacks, :payroll_id
    add_index :feedbacks, :registration_id
  end
end

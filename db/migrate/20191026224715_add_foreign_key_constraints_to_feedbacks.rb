class AddForeignKeyConstraintsToFeedbacks < ActiveRecord::Migration
  def change
    add_foreign_key :feedbacks, :bankpayments
    add_foreign_key :feedbacks, :payrolls
    add_foreign_key :feedbacks, :registrations
  end
end

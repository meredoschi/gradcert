class Fixfeedback < ActiveRecord::Migration[4.2]
  def change
    change_table :feedbacks do |t|
      t.remove :bankpayment_id
    end
    add_column :feedbacks, :payroll_id, :integer
   end
end

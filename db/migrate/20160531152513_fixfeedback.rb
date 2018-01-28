class Fixfeedback < ActiveRecord::Migration
  def change
    change_table :feedbacks do |t|
      t.remove :bankpayment_id
    end
    add_column :feedbacks, :payroll_id, :integer
   end
end

class FixStatement < ActiveRecord::Migration
  def change
    change_table :statements do |t|
      t.remove :payroll_id
    end
    add_column :registrations, :bankpayment_id, :integer
  end
end

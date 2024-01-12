class CreateBankpayments < ActiveRecord::Migration[4.2]
  def change
    create_table :bankpayments do |t|
      t.integer :payroll_id
      t.string :comment, limit: 150
      t.boolean :sent, default: false
      t.timestamps null: false
    end
  end
end

class AddPreparedRemoveSentFromBankpayment < ActiveRecord::Migration
  def change
    add_column :bankpayments, :prepared, :boolean, default: false

    change_table :bankpayments do |t|
      t.remove :sent
    end
  end
end

class CreateBankaccounts < ActiveRecord::Migration[4.2]
  def change
    create_table :bankaccounts do |t|
      t.string :num, limit: 12
      t.integer :digit, limit: 1
      t.integer :branchnum, limit: 5
      t.string :branchdigit, limit: 1
      t.string :controldigit, limit: 1
      t.timestamps null: false
    end
  end
end

class IndexStudentByBankaccountId < ActiveRecord::Migration[4.2]
  def change
    add_index :students, :bankaccount_id, unique: true
  end
end

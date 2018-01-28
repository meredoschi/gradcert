class IndexStudentByBankaccountId < ActiveRecord::Migration
  def change
    add_index :students, :bankaccount_id, unique: true
  end
end

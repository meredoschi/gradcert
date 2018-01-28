class AddBankAccountIdToStudent < ActiveRecord::Migration
  def change
    add_column :students, :bankaccount_id, :integer
  end
end

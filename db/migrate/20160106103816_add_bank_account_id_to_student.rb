class AddBankAccountIdToStudent < ActiveRecord::Migration[4.2]
  def change
    add_column :students, :bankaccount_id, :integer
  end
end

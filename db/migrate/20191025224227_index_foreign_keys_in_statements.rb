class IndexForeignKeysInStatements < ActiveRecord::Migration
  def change
    add_index :statements, :bankpayment_id
  end
end

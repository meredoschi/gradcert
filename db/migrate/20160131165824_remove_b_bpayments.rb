class RemoveBBpayments < ActiveRecord::Migration
  def change
    drop_table :bbpayments if table_exists?(:bbpayments)
  end
end

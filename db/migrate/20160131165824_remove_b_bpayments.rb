class RemoveBBpayments < ActiveRecord::Migration[4.2]
  def change
    drop_table :bbpayments if table_exists?(:bbpayments)
  end
end

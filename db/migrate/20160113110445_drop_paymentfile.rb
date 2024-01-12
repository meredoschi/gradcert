class DropPaymentfile < ActiveRecord::Migration[4.2]
  def change
    drop_table :paymentfiles if table_exists?(:paymentfiles)
  end
end

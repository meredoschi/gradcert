class DropPaymentfile < ActiveRecord::Migration
  def change
    drop_table :paymentfiles if table_exists?(:paymentfiles)
  end
end

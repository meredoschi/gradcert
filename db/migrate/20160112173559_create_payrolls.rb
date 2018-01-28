class CreatePayrolls < ActiveRecord::Migration
  def change
    drop_table :payrolls if table_exists?(:payrolls)

    create_table :payrolls do |t|
      t.date :paymentdate, null: false
      t.string :comment

      t.timestamps null: false
    end
  end
end

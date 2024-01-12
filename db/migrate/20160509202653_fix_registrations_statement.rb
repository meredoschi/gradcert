class FixRegistrationsStatement < ActiveRecord::Migration[4.2]
  def change
    change_table :registrations do |t|
      t.remove :bankpayment_id
    end
    add_column :statements, :bankpayment_id, :integer
  end
end

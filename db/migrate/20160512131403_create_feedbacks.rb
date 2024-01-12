class CreateFeedbacks < ActiveRecord::Migration[4.2]
  def change
    create_table :feedbacks do |t|
      t.integer :registration_id
      t.integer :bankpayment_id
      t.date :returndate
      t.boolean :returned, default: true
      t.boolean :missed, default: false

      t.timestamps null: false
    end
  end
end

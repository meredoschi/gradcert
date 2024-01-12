class CreateScholarships < ActiveRecord::Migration[4.2]
  def change
    create_table :scholarships do |t|
      t.integer :amount, default: 0
      t.date :start
      t.date :finish
      t.timestamps null: false
    end
  end
end

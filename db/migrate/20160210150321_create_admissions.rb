class CreateAdmissions < ActiveRecord::Migration
  def change
    create_table :admissions do |t|
      t.date :started
      t.integer :candidates
      t.integer :absentfirstexam
      t.integer :absentfinalexam
      t.integer :passedfirstexam
      t.integer :appealsdenied
      t.integer :appealsgranted
      t.integer :approved
      t.integer :convoked
      t.date :finished

      t.timestamps null: false
    end
  end
end

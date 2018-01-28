class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.integer :contact_id, null: false
      t.integer :profession_id
      t.integer :council_id
      t.timestamps null: false
    end
  end
end

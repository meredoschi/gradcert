class CreateAnnotations < ActiveRecord::Migration[4.2]
  def change
    create_table :annotations do |t|
      t.integer :registration_id, null: false
      t.integer :payroll_id, null: false
      t.integer :absences
      t.integer :discount
      t.boolean :skip, default: false
      t.string :comment, limit: 150
      t.timestamps null: false
    end
  end
end

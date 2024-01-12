class CreateAdvisements < ActiveRecord::Migration[4.2]
  def change
    create_table :advisements do |t|
      t.integer :supervisor_id
      t.integer :program_id
      t.boolean :lead
      t.date :start_date

      t.timestamps
    end
  end
end

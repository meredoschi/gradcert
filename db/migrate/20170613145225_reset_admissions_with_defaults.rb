class ResetAdmissionsWithDefaults < ActiveRecord::Migration[4.2]
  def change
    change_table :admissions do |t|
      t.remove  :candidates
      t.integer :candidates, default: 0, null: false

      t.remove  :absentfirstexam
      t.integer :absentfirstexam, default: 0, null: false

      t.remove  :absentfinalexam
      t.integer :absentfinalexam, default: 0, null: false

      t.remove  :passedfirstexam
      t.integer :passedfirstexam, default: 0, null: false

      t.remove  :appealsdeniedfirstexam
      t.integer :appealsdeniedfirstexam, default: 0, null: false

      t.remove  :appealsgrantedfirstexam
      t.integer :appealsgrantedfirstexam, default: 0, null: false

      t.remove  :admitted
      t.integer :admitted, default: 0, null: false

      t.remove  :convoked
      t.integer :convoked, default: 0, null: false
    end
  end
end

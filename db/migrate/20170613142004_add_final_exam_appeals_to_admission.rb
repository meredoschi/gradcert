class AddFinalExamAppealsToAdmission < ActiveRecord::Migration[4.2]
  def change
    change_table :admissions do |t|
      t.rename :appealsgranted, :appealsgrantedfirstexam
      t.rename :appealsdenied, :appealsdeniedfirstexam
      t.integer :appealsgrantedfinalexam, default: 0, null: false
      t.integer :appealsdeniedfinalexam, default: 0, null: false
    end
  end
end

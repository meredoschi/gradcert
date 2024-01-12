class AddInsufficientFinalExamGradeToAdmission < ActiveRecord::Migration[4.2]
  def change
    add_column :admissions, :insufficientfinalexamgrade, :integer, null: false, default: 0
  end
end

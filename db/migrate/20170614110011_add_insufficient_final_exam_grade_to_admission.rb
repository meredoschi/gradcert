class AddInsufficientFinalExamGradeToAdmission < ActiveRecord::Migration
  def change
    add_column :admissions, :insufficientfinalexamgrade, :integer, null: false, default: 0
  end
end

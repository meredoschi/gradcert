class RenameAssesmentsToAssessments < ActiveRecord::Migration[4.2]
  def change
    rename_table :assesments, :assessments
  end
end

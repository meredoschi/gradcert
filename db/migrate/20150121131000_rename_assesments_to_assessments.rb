class RenameAssesmentsToAssessments < ActiveRecord::Migration
  def change
    rename_table :assesments, :assessments
  end
end

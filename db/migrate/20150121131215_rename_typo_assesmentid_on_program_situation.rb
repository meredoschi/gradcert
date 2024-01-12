class RenameTypoAssesmentidOnProgramSituation < ActiveRecord::Migration[4.2]
  def change
    rename_column(:programsituations, :assesment_id, :assessment_id)
  end
end

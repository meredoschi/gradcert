class RenameTypoAssesmentidOnProgramSituation < ActiveRecord::Migration
  def change
    rename_column(:programsituations, :assesment_id, :assessment_id)
  end
end

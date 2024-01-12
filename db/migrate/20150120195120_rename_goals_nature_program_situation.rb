class RenameGoalsNatureProgramSituation < ActiveRecord::Migration[4.2]
  def change
    rename_column(:programsituations, :summary_of_program_goals, :goals)
    rename_column(:programsituations, :program_nature, :kind)
  end
end

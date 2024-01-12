class AddSeasonDebutSeasonClosureToSchoolterm < ActiveRecord::Migration[4.2]
  def change
    add_column :schoolterms, :seasondebut, :datetime
    add_column :schoolterms, :seasonclosure, :datetime
  end
end

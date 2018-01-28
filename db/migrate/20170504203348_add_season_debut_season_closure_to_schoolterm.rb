class AddSeasonDebutSeasonClosureToSchoolterm < ActiveRecord::Migration
  def change
    add_column :schoolterms, :seasondebut, :datetime
    add_column :schoolterms, :seasonclosure, :datetime
  end
end

class RemoveActiveFromSchoolterm < ActiveRecord::Migration
  def change
    remove_column :schoolterms, :active
  end
end

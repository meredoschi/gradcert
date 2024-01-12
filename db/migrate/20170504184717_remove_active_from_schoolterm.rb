class RemoveActiveFromSchoolterm < ActiveRecord::Migration[4.2]
  def change
    remove_column :schoolterms, :active
  end
end

class AddRegionalofficeidToMunicipalities < ActiveRecord::Migration
  def change
    add_column :municipalities, :regionaloffice_id, :integer
  end
end

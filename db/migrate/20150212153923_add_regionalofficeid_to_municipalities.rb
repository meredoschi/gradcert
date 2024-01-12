class AddRegionalofficeidToMunicipalities < ActiveRecord::Migration[4.2]
  def change
    add_column :municipalities, :regionaloffice_id, :integer
  end
end

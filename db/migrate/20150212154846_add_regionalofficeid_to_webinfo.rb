class AddRegionalofficeidToWebinfo < ActiveRecord::Migration[4.2]
  def change
    add_column :webinfos, :regionaloffice_id, :integer
  end
end

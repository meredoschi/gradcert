class AddRegionalofficeidToWebinfo < ActiveRecord::Migration
  def change
    add_column :webinfos, :regionaloffice_id, :integer
  end
end

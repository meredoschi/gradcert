class AddRegionalofficeidToPhone < ActiveRecord::Migration
  def change
    add_column :phones, :regionaloffice_id, :integer
  end
end

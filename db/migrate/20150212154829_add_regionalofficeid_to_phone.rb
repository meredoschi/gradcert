class AddRegionalofficeidToPhone < ActiveRecord::Migration[4.2]
  def change
    add_column :phones, :regionaloffice_id, :integer
  end
end

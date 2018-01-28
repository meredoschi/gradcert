class AddRegionalofficeidToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :regionaloffice_id, :integer
  end
end

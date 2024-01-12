class AddRegionalofficeidToAddress < ActiveRecord::Migration[4.2]
  def change
    add_column :addresses, :regionaloffice_id, :integer
  end
end

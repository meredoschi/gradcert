class AddInactiveToProgramname < ActiveRecord::Migration[4.2]
  def change
    add_column :programnames, :inactive, :boolean, default: false
  end
end

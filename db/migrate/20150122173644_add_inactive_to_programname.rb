class AddInactiveToProgramname < ActiveRecord::Migration
  def change
    add_column :programnames, :inactive, :boolean, default: false
  end
end

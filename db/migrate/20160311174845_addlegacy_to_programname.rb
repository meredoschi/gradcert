class AddlegacyToProgramname < ActiveRecord::Migration
  def change
    add_column :programnames, :legacy, :boolean, default: false
  end
end

class AddlegacyToProgramname < ActiveRecord::Migration[4.2]
  def change
    add_column :programnames, :legacy, :boolean, default: false
  end
end

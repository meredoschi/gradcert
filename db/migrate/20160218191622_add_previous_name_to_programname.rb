class AddPreviousNameToProgramname < ActiveRecord::Migration
  def change
    add_column :programnames, :previousname, :string, limit: 200
  end
end

class AddPreviousNameToProgramname < ActiveRecord::Migration[4.2]
  def change
    add_column :programnames, :previousname, :string, limit: 200
  end
end

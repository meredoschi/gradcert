class AddParentIdToProgramname < ActiveRecord::Migration[4.2]
  def change
    add_column :programnames, :parentid, :integer
  end
end

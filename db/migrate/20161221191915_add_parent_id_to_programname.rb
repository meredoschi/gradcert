class AddParentIdToProgramname < ActiveRecord::Migration
  def change
    add_column :programnames, :parentid, :integer
  end
end

class AddAncestorIdToProgramname < ActiveRecord::Migration
  def change
    add_column :programnames, :ancestor_id, :integer
  end
end

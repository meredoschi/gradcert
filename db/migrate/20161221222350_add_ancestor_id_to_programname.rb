class AddAncestorIdToProgramname < ActiveRecord::Migration[4.2]
  def change
    add_column :programnames, :ancestor_id, :integer
  end
end

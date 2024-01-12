class AddArchivedToEvent < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :archived, :boolean, default: false
  end
end

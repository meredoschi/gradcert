class RenameInactiveToActive < ActiveRecord::Migration[4.2]
  def change
    rename_column :programnames, :inactive, :active
    change_column :programnames, :active, :boolean, default: true

    rename_column :programs, :inactive, :active
    change_column :programs, :active, :boolean, default: true
  end
end

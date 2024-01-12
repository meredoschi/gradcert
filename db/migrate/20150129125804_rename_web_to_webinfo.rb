class RenameWebToWebinfo < ActiveRecord::Migration[4.2]
  def change
    rename_table :webs, :webinfos
  end
end

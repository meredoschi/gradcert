class RenameWebToWebinfo < ActiveRecord::Migration
  def change
    rename_table :webs, :webinfos
  end
end

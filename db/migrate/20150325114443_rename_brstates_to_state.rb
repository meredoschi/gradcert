class RenameBrstatesToState < ActiveRecord::Migration
  def change
    rename_table :brstates, :states
  end
end

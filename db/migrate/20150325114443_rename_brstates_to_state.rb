class RenameBrstatesToState < ActiveRecord::Migration[4.2]
  def change
    rename_table :brstates, :states
  end
end

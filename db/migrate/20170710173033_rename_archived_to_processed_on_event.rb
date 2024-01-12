class RenameArchivedToProcessedOnEvent < ActiveRecord::Migration[4.2]
  def change
    change_table :events do |t|
      t.rename :archived, :processed
    end
  end
end

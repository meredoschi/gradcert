class RenameArchivedToProcessedOnEvent < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.rename :archived, :processed
    end
  end
end

class RemoveFinishedAddOngoingToDiploma < ActiveRecord::Migration
  def change
    remove_column :diplomas, :finished, :boolean
    add_column :diplomas, :ongoing, :boolean, default: false
  end
end

class RemoveFinishedAddOngoingToDiploma < ActiveRecord::Migration[4.2]
  def change
    remove_column :diplomas, :finished, :boolean
    add_column :diplomas, :ongoing, :boolean, default: false
  end
end

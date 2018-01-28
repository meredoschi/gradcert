class AddPreviousparticipantToStudent < ActiveRecord::Migration
  def change
    add_column :students, :previousparticipant, :boolean, default: false
  end
end

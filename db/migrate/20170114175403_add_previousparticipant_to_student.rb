class AddPreviousparticipantToStudent < ActiveRecord::Migration[4.2]
  def change
    add_column :students, :previousparticipant, :boolean, default: false
  end
end

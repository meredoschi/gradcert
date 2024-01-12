class AddSupervisorIdToDiploma < ActiveRecord::Migration[4.2]
  def change
    add_column :diplomas, :supervisor_id, :integer
  end
end

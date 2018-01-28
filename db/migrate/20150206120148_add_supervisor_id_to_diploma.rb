class AddSupervisorIdToDiploma < ActiveRecord::Migration
  def change
    add_column :diplomas, :supervisor_id, :integer
  end
end

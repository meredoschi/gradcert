class RemoveProgramsupervisor < ActiveRecord::Migration[4.2]
  def change
    drop_table :programsupervisors
  end
end

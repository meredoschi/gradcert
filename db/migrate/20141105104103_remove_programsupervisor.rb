class RemoveProgramsupervisor < ActiveRecord::Migration
  def change
    drop_table :programsupervisors
  end
end

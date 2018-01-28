class AddProgramIdToSupervisors < ActiveRecord::Migration
  def change
    add_column :supervisors, :program_id, :integer
  end
end

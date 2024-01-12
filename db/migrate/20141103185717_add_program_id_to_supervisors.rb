class AddProgramIdToSupervisors < ActiveRecord::Migration[4.2]
  def change
    add_column :supervisors, :program_id, :integer
  end
end

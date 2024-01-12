class AddProgramIdToSchoolyear < ActiveRecord::Migration[4.2]
  def change
    add_column :schoolyears, :program_id, :integer
  end
end

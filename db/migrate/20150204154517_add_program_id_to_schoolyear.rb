class AddProgramIdToSchoolyear < ActiveRecord::Migration
  def change
    add_column :schoolyears, :program_id, :integer
  end
end

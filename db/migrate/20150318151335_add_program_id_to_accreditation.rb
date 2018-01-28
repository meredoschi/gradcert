class AddProgramIdToAccreditation < ActiveRecord::Migration
  def change
    add_column :accreditations, :program_id, :integer
  end
end

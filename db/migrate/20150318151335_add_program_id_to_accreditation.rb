class AddProgramIdToAccreditation < ActiveRecord::Migration[4.2]
  def change
    add_column :accreditations, :program_id, :integer
  end
end

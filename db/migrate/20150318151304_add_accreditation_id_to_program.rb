class AddAccreditationIdToProgram < ActiveRecord::Migration[4.2]
  def change
    add_column :programs, :accreditation_id, :integer
  end
end

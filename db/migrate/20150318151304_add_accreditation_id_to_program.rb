class AddAccreditationIdToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :accreditation_id, :integer
  end
end

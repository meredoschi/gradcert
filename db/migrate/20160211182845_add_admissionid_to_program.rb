class AddAdmissionidToProgram < ActiveRecord::Migration[4.2]
  def change
    add_column :programs, :admission_id, :integer
  end
end

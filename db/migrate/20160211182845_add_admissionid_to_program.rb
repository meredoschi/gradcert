class AddAdmissionidToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :admission_id, :integer
  end
end

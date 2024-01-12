class AddScholarshipidToPayroll < ActiveRecord::Migration[4.2]
  def change
    add_column :payrolls, :scholarship_id, :integer
  end
end

class AddScholarshipidToPayroll < ActiveRecord::Migration
  def change
    add_column :payrolls, :scholarship_id, :integer
  end
end

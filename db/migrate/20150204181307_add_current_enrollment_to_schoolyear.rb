class AddCurrentEnrollmentToSchoolyear < ActiveRecord::Migration
  def change
    add_column :schoolyears, :scholarships, :integer
    add_column :schoolyears, :enrollment, :integer
  end
end

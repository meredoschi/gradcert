class AddCurrentEnrollmentToSchoolyear < ActiveRecord::Migration[4.2]
  def change
    add_column :schoolyears, :scholarships, :integer
    add_column :schoolyears, :enrollment, :integer
  end
end

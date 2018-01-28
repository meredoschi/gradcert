class AddTotalEnrollmentToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :first_year_total_enrollment, :integer
    add_column :programs, :following_years_total_enrollment, :integer
  end
end

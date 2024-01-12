class AddTotalEnrollmentToPrograms < ActiveRecord::Migration[4.2]
  def change
    add_column :programs, :first_year_total_enrollment, :integer
    add_column :programs, :following_years_total_enrollment, :integer
  end
end

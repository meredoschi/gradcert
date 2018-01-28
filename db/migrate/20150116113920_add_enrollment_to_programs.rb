class AddEnrollmentToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :first_year_annual_grants, :integer
    add_column :programs, :following_years_annual_grants, :integer
  end
end

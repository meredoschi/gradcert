class RenameGrantEnrollmentonPrograms < ActiveRecord::Migration
  def change
    change_table :programs do |t|
      t.rename :first_year_annual_grants, :first_year_grants
      t.rename :first_year_total_enrollment, :first_year_enrollment
      t.rename :following_years_annual_grants, :second_year_grants
      t.rename :following_years_total_enrollment, :second_year_enrollment
    end
  end
end

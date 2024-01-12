class AddThirdFourthFifthYearToPrograms < ActiveRecord::Migration[4.2]
  def change
    add_column :programs, :third_year_grants, :integer
    add_column :programs, :third_year_enrollment, :integer
    add_column :programs, :fourth_year_grants, :integer
    add_column :programs, :fourth_year_enrollment, :integer
    add_column :programs, :fifth_year_grants, :integer
    add_column :programs, :fifth_year_enrollment, :integer
  end
end

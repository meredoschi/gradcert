class RemoveEnrollmentFromPrograms < ActiveRecord::Migration
  def change
    change_table :programs do |t|
      t.remove :first_year_grants
      t.remove :second_year_grants
      t.remove :first_year_enrollment
      t.remove :second_year_enrollment
      t.remove :third_year_grants
      t.remove :third_year_enrollment
      t.remove :fourth_year_grants
      t.remove :fourth_year_enrollment
      t.remove :fifth_year_grants
      t.remove :fifth_year_enrollment
    end
  end
end

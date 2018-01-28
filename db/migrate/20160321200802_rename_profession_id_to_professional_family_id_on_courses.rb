class RenameProfessionIdToProfessionalFamilyIdOnCourses < ActiveRecord::Migration
  def change
    change_table :courses do |t|
      t.rename :profession_id, :professionalfamily_id # for the sake of consistency in nomenclature
    end
  end
end

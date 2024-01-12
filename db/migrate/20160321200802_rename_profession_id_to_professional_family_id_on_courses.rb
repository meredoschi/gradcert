class RenameProfessionIdToProfessionalFamilyIdOnCourses < ActiveRecord::Migration[4.2]
  def change
    change_table :courses do |t|
      t.rename :profession_id, :professionalfamily_id # for the sake of consistency in nomenclature
    end
  end
end

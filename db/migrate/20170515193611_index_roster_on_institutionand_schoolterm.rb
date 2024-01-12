class IndexRosterOnInstitutionandSchoolterm < ActiveRecord::Migration[4.2]
  def change
    add_index :rosters, %i[institution_id schoolterm_id], unique: true
  end
end

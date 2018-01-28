class IndexRosterOnInstitutionandSchoolterm < ActiveRecord::Migration
  def change
    add_index :rosters, %i[institution_id schoolterm_id], unique: true
  end
end

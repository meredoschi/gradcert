class AddAdmissionsDataEntryScheduleToSchoolterm < ActiveRecord::Migration
  def change
    add_column :schoolterms, :admissionsdebut, :datetime
    add_column :schoolterms, :admissionsclosure, :datetime
  end
end

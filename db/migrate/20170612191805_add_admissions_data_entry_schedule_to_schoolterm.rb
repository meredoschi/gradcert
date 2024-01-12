class AddAdmissionsDataEntryScheduleToSchoolterm < ActiveRecord::Migration[4.2]
  def change
    add_column :schoolterms, :admissionsdebut, :datetime
    add_column :schoolterms, :admissionsclosure, :datetime
  end
end

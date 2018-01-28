class AddRegistrationseasonToSchoolterm < ActiveRecord::Migration
  def change
    add_column :schoolterms, :registrationseason, :boolean, default: false
  end
end

class AddRegistrationseasonToSchoolterm < ActiveRecord::Migration[4.2]
  def change
    add_column :schoolterms, :registrationseason, :boolean, default: false
  end
end

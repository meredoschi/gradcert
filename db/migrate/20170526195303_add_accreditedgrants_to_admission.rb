class AddAccreditedgrantsToAdmission < ActiveRecord::Migration[4.2]
  def change
    add_column :admissions, :accreditedgrants, :integer
  end
end

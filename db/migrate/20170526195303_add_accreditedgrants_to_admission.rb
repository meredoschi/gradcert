class AddAccreditedgrantsToAdmission < ActiveRecord::Migration
  def change
    add_column :admissions, :accreditedgrants, :integer
  end
end

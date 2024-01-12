class AddAllowregistrationsToPlacesavailable < ActiveRecord::Migration[4.2]
  def change
    add_column :placesavailables, :allowregistrations, :boolean, default: false
  end
end

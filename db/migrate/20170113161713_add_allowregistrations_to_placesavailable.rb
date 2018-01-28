class AddAllowregistrationsToPlacesavailable < ActiveRecord::Migration
  def change
    add_column :placesavailables, :allowregistrations, :boolean, default: false
  end
end

class AddForeignKeyConstraintsToPlacesavailables < ActiveRecord::Migration
  def change
    add_foreign_key :placesavailables, :institutions
    add_foreign_key :placesavailables, :schoolterms
  end
end

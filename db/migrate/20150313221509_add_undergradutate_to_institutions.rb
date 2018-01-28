class AddUndergradutateToInstitutions < ActiveRecord::Migration
  def change
    add_column :institutions, :undergraduate, :boolean, default: false
  end
end

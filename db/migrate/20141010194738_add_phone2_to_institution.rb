class AddPhone2ToInstitution < ActiveRecord::Migration
  def change
    add_column :institutions, :phone2, :string, limit: 30
  end
end

class AddPhone2ToInstitution < ActiveRecord::Migration[4.2]
  def change
    add_column :institutions, :phone2, :string, limit: 30
  end
end

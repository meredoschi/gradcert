class AddLegacyidToInstitution < ActiveRecord::Migration[4.2]
  def change
    add_column :institutions, :legacycode, :integer
  end
end

class AddLegacyidToInstitution < ActiveRecord::Migration
  def change
    add_column :institutions, :legacycode, :integer
  end
end

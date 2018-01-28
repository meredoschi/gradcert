class AddSectorToInstitution < ActiveRecord::Migration
  def change
    add_column :institutions, :sector, :string, limit: 40
  end
end

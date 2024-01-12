class AddSectorToInstitution < ActiveRecord::Migration[4.2]
  def change
    add_column :institutions, :sector, :string, limit: 40
  end
end

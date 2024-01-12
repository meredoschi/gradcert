class AddAbbreviationToInstitution < ActiveRecord::Migration[4.2]
  def change
    add_column :institutions, :abbreviation, :string, limit: 20
  end
end

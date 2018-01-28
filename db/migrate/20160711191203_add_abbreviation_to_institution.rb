class AddAbbreviationToInstitution < ActiveRecord::Migration
  def change
    add_column :institutions, :abbreviation, :string, limit: 20
  end
end

class AddAbbreviationToCouncils < ActiveRecord::Migration[4.2]
  def change
    add_column :councils, :abbreviation, :string, limit: 20
  end
end

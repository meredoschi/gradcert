class AddAbbreviationToCouncils < ActiveRecord::Migration
  def change
    add_column :councils, :abbreviation, :string, limit: 20
  end
end

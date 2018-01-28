class DecreaseStateAbbreviationTo10Chars < ActiveRecord::Migration
  def change
    change_column :states, :abbreviation, :string, limit: 10
  end
end

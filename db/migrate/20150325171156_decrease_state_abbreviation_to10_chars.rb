class DecreaseStateAbbreviationTo10Chars < ActiveRecord::Migration[4.2]
  def change
    change_column :states, :abbreviation, :string, limit: 10
  end
end

class AddCouncilToWebinfos < ActiveRecord::Migration[4.2]
  def change
    add_column :webinfos, :council_id, :integer
  end
end

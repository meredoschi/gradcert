class AddCouncilToWebinfos < ActiveRecord::Migration
  def change
    add_column :webinfos, :council_id, :integer
  end
end

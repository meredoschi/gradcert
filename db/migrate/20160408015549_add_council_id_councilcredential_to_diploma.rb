class AddCouncilIdCouncilcredentialToDiploma < ActiveRecord::Migration
  def change
    add_column :diplomas, :council_id, :integer
    add_column :diplomas, :councilcredential, :string, limit: 30
  end
end

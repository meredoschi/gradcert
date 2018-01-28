class AddCouncilcredentialexpirationToDiploma < ActiveRecord::Migration
  def change
    add_column :diplomas, :councilcredentialexpiration, :date
  end
end

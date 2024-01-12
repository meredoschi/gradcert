class AddCouncilcredentialexpirationToDiploma < ActiveRecord::Migration[4.2]
  def change
    add_column :diplomas, :councilcredentialexpiration, :date
  end
end

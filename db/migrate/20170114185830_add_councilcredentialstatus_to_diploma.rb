class AddCouncilcredentialstatusToDiploma < ActiveRecord::Migration[4.2]
  def change
    add_column :diplomas, :councilcredentialstatus, :string, limit: 30
  end
end

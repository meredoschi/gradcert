class AddCouncilcredentialstatusToDiploma < ActiveRecord::Migration
  def change
    add_column :diplomas, :councilcredentialstatus, :string, limit: 30
  end
end

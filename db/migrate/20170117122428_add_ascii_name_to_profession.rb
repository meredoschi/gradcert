class AddAsciiNameToProfession < ActiveRecord::Migration
  def change
    add_column :professions, :asciiname, :string, limit: 150
  end
end

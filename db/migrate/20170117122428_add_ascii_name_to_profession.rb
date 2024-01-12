class AddAsciiNameToProfession < ActiveRecord::Migration[4.2]
  def change
    add_column :professions, :asciiname, :string, limit: 150
  end
end

class AddAsciinameToMunicipality < ActiveRecord::Migration[4.2]
  def change
    add_column :municipalities, :asciiname, :string, limit: 50
  end
end

class AddAsciinameToMunicipality < ActiveRecord::Migration
  def change
    add_column :municipalities, :asciiname, :string, limit: 50
  end
end

class AddMothersnameToPersonalinfo < ActiveRecord::Migration
  def change
    add_column :personalinfos, :mothersname, :string, limit: 100
  end
end

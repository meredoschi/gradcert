class AddMothersnameToPersonalinfo < ActiveRecord::Migration[4.2]
  def change
    add_column :personalinfos, :mothersname, :string, limit: 100
  end
end

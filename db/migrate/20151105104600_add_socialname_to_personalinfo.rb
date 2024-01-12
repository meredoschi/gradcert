class AddSocialnameToPersonalinfo < ActiveRecord::Migration[4.2]
  def change
    add_column :personalinfos, :socialname, :string, limit: 30 # provided for transgender use
  end
end

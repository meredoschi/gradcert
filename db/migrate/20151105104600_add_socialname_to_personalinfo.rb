class AddSocialnameToPersonalinfo < ActiveRecord::Migration
  def change
    add_column :personalinfos, :socialname, :string, limit: 30 # provided for transgender use
  end
end

class RenameSocialnameToOthernameOnPersonalinfo < ActiveRecord::Migration
  def change
    change_table :personalinfos do |t|
      t.rename :socialname, :othername
    end
  end
end

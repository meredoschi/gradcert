class RenameSocialnameToOthernameOnPersonalinfo < ActiveRecord::Migration[4.2]
  def change
    change_table :personalinfos do |t|
      t.rename :socialname, :othername
    end
  end
end

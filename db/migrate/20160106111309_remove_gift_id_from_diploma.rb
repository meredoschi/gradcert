class RemoveGiftIdFromDiploma < ActiveRecord::Migration[4.2]
  def change
    change_table :diplomas do |t|
      t.remove :gift_id
    end
  end
end

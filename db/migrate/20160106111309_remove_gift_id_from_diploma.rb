class RemoveGiftIdFromDiploma < ActiveRecord::Migration
  def change
    change_table :diplomas do |t|
      t.remove :gift_id
    end
  end
end

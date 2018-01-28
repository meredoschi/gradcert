class RemoveGiftidFromAddresses < ActiveRecord::Migration
  def change
    change_table :addresses do |t|
      t.remove :gift_id # From development, nested model testing...
    end
    end
end

class AddGiftIdToDiploma < ActiveRecord::Migration[4.2]
  def change
    add_column :diplomas, :gift_id, :integer
  end
end

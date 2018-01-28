class AddGiftIdToDiploma < ActiveRecord::Migration
  def change
    add_column :diplomas, :gift_id, :integer
  end
end

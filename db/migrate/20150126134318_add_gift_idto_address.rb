class AddGiftIdtoAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :gift_id, :integer
  end
end

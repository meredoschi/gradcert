class AddGiftIdtoAddress < ActiveRecord::Migration[4.2]
  def change
    add_column :addresses, :gift_id, :integer
  end
end

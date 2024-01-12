class AddStreetnumberToAddress < ActiveRecord::Migration[4.2]
  def change
    add_column :addresses, :streetnum, :integer
  end
end

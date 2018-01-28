class AddStreetnumberToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :streetnum, :integer
  end
end

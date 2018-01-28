class AddHeaderToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :header, :string, limit: 120
  end
end

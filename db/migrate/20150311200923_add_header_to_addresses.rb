class AddHeaderToAddresses < ActiveRecord::Migration[4.2]
  def change
    add_column :addresses, :header, :string, limit: 120
  end
end

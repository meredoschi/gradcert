class AddInternalToAddress < ActiveRecord::Migration[4.2]
  def change
    add_column :addresses, :internal, :boolean, default: false
  end
end

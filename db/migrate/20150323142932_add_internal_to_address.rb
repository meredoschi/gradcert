class AddInternalToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :internal, :boolean, default: false
  end
end

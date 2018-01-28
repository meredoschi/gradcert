class AddTaxrateToBracket < ActiveRecord::Migration
  def change
    add_column :brackets, :rate, :integer, default: 0
  end
end

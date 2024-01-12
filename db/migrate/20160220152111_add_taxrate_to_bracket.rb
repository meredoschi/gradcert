class AddTaxrateToBracket < ActiveRecord::Migration[4.2]
  def change
    add_column :brackets, :rate, :integer, default: 0
  end
end

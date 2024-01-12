class ChangeBracketRateToDecimal < ActiveRecord::Migration[4.2]
  def change
    change_column :brackets, :rate, :decimal, precision: 5, scale: 2
  end
end

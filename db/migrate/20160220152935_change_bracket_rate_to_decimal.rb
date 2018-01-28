class ChangeBracketRateToDecimal < ActiveRecord::Migration
  def change
    change_column :brackets, :rate, :decimal, precision: 5, scale: 2
  end
end

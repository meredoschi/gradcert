class AddDeductibleToBracket < ActiveRecord::Migration
  def change
    add_column :brackets, :deductible, :integer, default: 0
  end
end

class AddDeductibleToBracket < ActiveRecord::Migration[4.2]
  def change
    add_column :brackets, :deductible, :integer, default: 0
  end
end

class MonetizeStartFinishDeductibleOnBracket < ActiveRecord::Migration[4.2]
  def change
    change_table :brackets do |t|
      t.rename :start, :start_cents
      t.rename :finish, :finish_cents
      t.rename :deductible, :deductible_cents
    end
  end
end

class RenameAmountPartialAmountToCentsOnScholarships < ActiveRecord::Migration
  def change
    change_table :scholarships do |t|
      t.rename :amount, :amount_cents
      t.rename :partialamount, :partialamount_cents
    end
  end
end

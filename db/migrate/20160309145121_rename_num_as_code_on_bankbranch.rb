class RenameNumAsCodeOnBankbranch < ActiveRecord::Migration
  def change
    change_table :bankbranches do |t|
      t.rename :num, :code # for the sake of consistency in nomenclature
    end
  end
end

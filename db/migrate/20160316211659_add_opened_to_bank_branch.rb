class AddOpenedToBankBranch < ActiveRecord::Migration
  def change
    add_column :bankbranches, :opened, :date
  end
end

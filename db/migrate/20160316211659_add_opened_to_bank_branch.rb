class AddOpenedToBankBranch < ActiveRecord::Migration[4.2]
  def change
    add_column :bankbranches, :opened, :date
  end
end

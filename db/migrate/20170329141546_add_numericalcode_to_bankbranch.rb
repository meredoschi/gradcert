class AddNumericalcodeToBankbranch < ActiveRecord::Migration
  def change
    add_column :bankbranches, :numericalcode, :integer
  end
end

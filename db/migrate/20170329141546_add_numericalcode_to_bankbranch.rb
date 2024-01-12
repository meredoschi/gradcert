class AddNumericalcodeToBankbranch < ActiveRecord::Migration[4.2]
  def change
    add_column :bankbranches, :numericalcode, :integer
  end
end

class RemoveDoneFromPayroll < ActiveRecord::Migration[4.2]
  # Marcelo - July 2017
  # Information will come from the associated bankpayment attribute
  def change
    remove_column :payrolls, :done
  end
end

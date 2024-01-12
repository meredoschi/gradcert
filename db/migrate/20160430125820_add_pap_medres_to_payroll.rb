class AddPapMedresToPayroll < ActiveRecord::Migration[4.2]
  def change
    add_column :payrolls, :pap, :boolean, default: false
    add_column :payrolls, :medres, :boolean, default: false
  end
end

class AddPapMedresToPayroll < ActiveRecord::Migration
  def change
    add_column :payrolls, :pap, :boolean, default: false
    add_column :payrolls, :medres, :boolean, default: false
  end
end

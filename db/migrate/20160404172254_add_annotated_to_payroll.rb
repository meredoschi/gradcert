class AddAnnotatedToPayroll < ActiveRecord::Migration
  def change
    add_column :payrolls, :annotated, :boolean, default: false
  end
end

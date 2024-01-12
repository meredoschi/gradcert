class AddAnnotatedToPayroll < ActiveRecord::Migration[4.2]
  def change
    add_column :payrolls, :annotated, :boolean, default: false
  end
end

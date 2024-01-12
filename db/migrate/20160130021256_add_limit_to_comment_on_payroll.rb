class AddLimitToCommentOnPayroll < ActiveRecord::Migration[4.2]
  def change
    change_column :payrolls, :comment, :string, limit: 200
  end
end

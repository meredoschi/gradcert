class AddLimitToCommentOnPayroll < ActiveRecord::Migration
  def change
    change_column :payrolls, :comment, :string, limit: 200
  end
end

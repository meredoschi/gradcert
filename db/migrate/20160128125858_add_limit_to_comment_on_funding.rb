class AddLimitToCommentOnFunding < ActiveRecord::Migration
  def change
    change_column :fundings, :comment, :string, limit: 200
  end
end

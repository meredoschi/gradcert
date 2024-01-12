class AddLimitToCommentOnFunding < ActiveRecord::Migration[4.2]
  def change
    change_column :fundings, :comment, :string, limit: 200
  end
end

class AddCommentToFeedback < ActiveRecord::Migration
  def change
    add_column :feedbacks, :comment, :string, limit: 200
  end
end

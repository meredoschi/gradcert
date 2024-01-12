class AddCommentToFeedback < ActiveRecord::Migration[4.2]
  def change
    add_column :feedbacks, :comment, :string, limit: 200
  end
end

class AddCommentToProgramname < ActiveRecord::Migration[4.2]
  def change
    add_column :programnames, :comment, :string, limit: 200
  end
end

class AddCommentToProgramname < ActiveRecord::Migration
  def change
    add_column :programnames, :comment, :string, limit: 200
  end
end

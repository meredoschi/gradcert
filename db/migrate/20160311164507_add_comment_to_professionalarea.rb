class AddCommentToProfessionalarea < ActiveRecord::Migration
  def change
    add_column :professionalareas, :comment, :string, limit: 250
  end
end

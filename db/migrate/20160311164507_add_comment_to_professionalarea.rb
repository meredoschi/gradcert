class AddCommentToProfessionalarea < ActiveRecord::Migration[4.2]
  def change
    add_column :professionalareas, :comment, :string, limit: 250
  end
end

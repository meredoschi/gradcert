class AddCommentToProfessionalspecialty < ActiveRecord::Migration
  def change
    add_column :professionalspecialties, :comment, :string, limit: 250
  end
end

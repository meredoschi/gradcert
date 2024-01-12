class AddCommentToProfessionalspecialty < ActiveRecord::Migration[4.2]
  def change
    add_column :professionalspecialties, :comment, :string, limit: 250
  end
end

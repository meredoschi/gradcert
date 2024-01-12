class AddCouncilidToProfessionalfamily < ActiveRecord::Migration[4.2]
  def change
    add_column :professionalfamilies, :council_id, :integer
  end
end

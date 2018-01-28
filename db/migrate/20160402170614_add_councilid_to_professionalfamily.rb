class AddCouncilidToProfessionalfamily < ActiveRecord::Migration
  def change
    add_column :professionalfamilies, :council_id, :integer
  end
end

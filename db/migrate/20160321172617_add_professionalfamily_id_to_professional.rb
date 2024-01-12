class AddProfessionalfamilyIdToProfessional < ActiveRecord::Migration[4.2]
  def change
    add_column :professions, :professionalfamily_id, :integer
  end
end

class AddProfessionalfamilyIdToProfessional < ActiveRecord::Migration
  def change
    add_column :professions, :professionalfamily_id, :integer
  end
end

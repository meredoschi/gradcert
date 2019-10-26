class AddForeignKeyConstraintsToProfessionalfamilies < ActiveRecord::Migration
  def change
    add_foreign_key :professionalfamilies, :councils
#    add_foreign_key :professionalfamilies, :subgroups
  end
end

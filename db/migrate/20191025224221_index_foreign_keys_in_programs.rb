class IndexForeignKeysInPrograms < ActiveRecord::Migration
  def change
    add_index :programs, :accreditation_id
    add_index :programs, :address_id
    add_index :programs, :admission_id
    add_index :programs, :professionalspecialty_id
    add_index :programs, :schoolterm_id
  end
end

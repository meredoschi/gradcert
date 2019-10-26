class AddForeignKeyConstraintsToProfessions < ActiveRecord::Migration
  def change
    add_foreign_key :professions, :professionalfamilies
  end
end

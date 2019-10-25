class IndexForeignKeysInProfessionalspecialties < ActiveRecord::Migration
  def change
    add_index :professionalspecialties, :professionalarea_id
  end
end

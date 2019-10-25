class IndexForeignKeysInInstitutions < ActiveRecord::Migration
  def change
    add_index :institutions, :accreditation_id
    add_index :institutions, :address_id
    add_index :institutions, :institutiontype_id
    add_index :institutions, :phone_id
    add_index :institutions, :webinfo_id
  end
end

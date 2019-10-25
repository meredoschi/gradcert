class IndexForeignKeysInPhones < ActiveRecord::Migration
  def change
    add_index :phones, :bankbranch_id
    add_index :phones, :council_id
    add_index :phones, :institution_id
    add_index :phones, :regionaloffice_id
  end
end

class IndexForeignKeysInAddresses < ActiveRecord::Migration
  def change
    add_index :addresses, :bankbranch_id
    add_index :addresses, :council_id
    add_index :addresses, :country_id
    add_index :addresses, :course_id
    add_index :addresses, :institution_id
    add_index :addresses, :program_id
    add_index :addresses, :regionaloffice_id
    add_index :addresses, :streetname_id
  end
end

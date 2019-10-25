class IndexForeignKeysInAccreditations < ActiveRecord::Migration
  def change
    add_index :accreditations, :program_id
    add_index :accreditations, :registration_id
  end
end

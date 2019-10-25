class IndexForeignKeysInAdmissions < ActiveRecord::Migration
  def change
    add_index :admissions, :program_id
  end
end

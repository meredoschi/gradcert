class AddIndexToAddress < ActiveRecord::Migration
  def change
    add_index :addresses, %i[contact_id institution_id]
  end
end

class AddIndexToAddress < ActiveRecord::Migration[4.2]
  def change
    add_index :addresses, %i[contact_id institution_id]
  end
end

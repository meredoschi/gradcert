class AddIndexToPhone < ActiveRecord::Migration[4.2]
  def change
    add_index :phones, %i[contact_id institution_id]
  end
end

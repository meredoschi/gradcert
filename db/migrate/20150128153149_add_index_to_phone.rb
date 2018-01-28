class AddIndexToPhone < ActiveRecord::Migration
  def change
    add_index :phones, %i[contact_id institution_id]
  end
end

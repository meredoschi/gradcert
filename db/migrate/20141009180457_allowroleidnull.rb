class Allowroleidnull < ActiveRecord::Migration[4.2]
  def change
    change_column_null(:contacts, :role_id, true)
  end
end

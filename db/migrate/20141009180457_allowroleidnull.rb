class Allowroleidnull < ActiveRecord::Migration
  def change
    change_column_null(:contacts, :role_id, true)
  end
end

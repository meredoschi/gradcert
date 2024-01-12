class IndexContactOnRoleid < ActiveRecord::Migration[4.2]
  def change
    add_index :contacts, :role_id
  end
end

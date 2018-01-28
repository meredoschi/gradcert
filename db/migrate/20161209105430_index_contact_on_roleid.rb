class IndexContactOnRoleid < ActiveRecord::Migration
  def change
    add_index :contacts, :role_id
  end
end

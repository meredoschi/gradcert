class DropBankfile < ActiveRecord::Migration
  def change
    drop_table :bankfiles if table_exists?(:bankfiles)
  end
end

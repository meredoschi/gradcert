class DropBankfile < ActiveRecord::Migration[4.2]
  def change
    drop_table :bankfiles if table_exists?(:bankfiles)
  end
end

class IndexForeignKeysInTaxations < ActiveRecord::Migration
  def change
    add_index :taxations, :bracket_id
  end
end

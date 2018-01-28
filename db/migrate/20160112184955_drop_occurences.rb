class DropOccurences < ActiveRecord::Migration
  def change
    drop_table :occurrences if table_exists?(:occurrences)
  end
end

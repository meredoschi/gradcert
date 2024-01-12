class DropOccurences < ActiveRecord::Migration[4.2]
  def change
    drop_table :occurrences if table_exists?(:occurrences)
  end
end

class FixOccurrences < ActiveRecord::Migration
  def change
    if table_exists?(:occurrences)

      change_table :occurrences do |t|
        t.remove :student_id
      end
      add_column :occurrences, :registration_id, :integer
       end
     end
end

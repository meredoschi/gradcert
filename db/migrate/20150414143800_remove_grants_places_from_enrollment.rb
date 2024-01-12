class RemoveGrantsPlacesFromEnrollment < ActiveRecord::Migration[4.2]
  def change
    if table_exists?(:enrollments)

      change_table :enrollments do |t|
        t.remove :grants
        t.remove :places
      end
    end
  end
end

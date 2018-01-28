class RemoveGrantsPlacesFromEnrollment < ActiveRecord::Migration
  def change
    if table_exists?(:enrollments)

      change_table :enrollments do |t|
        t.remove :grants
        t.remove :places
      end
    end
  end
end

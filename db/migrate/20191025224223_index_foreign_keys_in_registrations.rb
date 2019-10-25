class IndexForeignKeysInRegistrations < ActiveRecord::Migration
  def change
    add_index :registrations, :accreditation_id
    add_index :registrations, :completion_id
    add_index :registrations, :registrationkind_id
    add_index :registrations, :schoolyear_id
  end
end

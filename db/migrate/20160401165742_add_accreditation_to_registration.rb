class AddAccreditationToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :accreditation_id, :integer
  end
end

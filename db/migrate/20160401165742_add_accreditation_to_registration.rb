class AddAccreditationToRegistration < ActiveRecord::Migration[4.2]
  def change
    add_column :registrations, :accreditation_id, :integer
  end
end

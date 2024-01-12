class AddRegistrationkindidToRegistration < ActiveRecord::Migration[4.2]
  def change
    add_column :registrations, :registrationkind_id, :integer
  end
end

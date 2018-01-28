class AddRegistrationkindidToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :registrationkind_id, :integer
  end
end

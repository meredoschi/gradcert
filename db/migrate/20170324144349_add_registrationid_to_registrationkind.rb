class AddRegistrationidToRegistrationkind < ActiveRecord::Migration[4.2]
  def change
    add_column :registrationkinds, :registration_id, :integer
    add_index :registrationkinds, :registration_id, unique: true
  end
end

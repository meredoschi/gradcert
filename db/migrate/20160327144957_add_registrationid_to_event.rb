class AddRegistrationidToEvent < ActiveRecord::Migration
  def change
    add_column :events, :registration_id, :integer
  end
end

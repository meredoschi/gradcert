class AddRegistrationIdToAccreditation < ActiveRecord::Migration[4.2]
  def change
    add_column :accreditations, :registration_id, :integer
  end
end

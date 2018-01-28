class AddRegistrationIdToAccreditation < ActiveRecord::Migration
  def change
    add_column :accreditations, :registration_id, :integer
  end
end

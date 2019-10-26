class AddForeignKeyConstraintsToRegistrationkinds < ActiveRecord::Migration
  def change
    add_foreign_key :registrationkinds, :registrations
  end
end

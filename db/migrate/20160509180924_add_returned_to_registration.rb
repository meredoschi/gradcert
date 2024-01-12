class AddReturnedToRegistration < ActiveRecord::Migration[4.2]
  def change
    add_column :registrations, :returned, :boolean, default: false
  end
end

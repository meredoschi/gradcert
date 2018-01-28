class AddReturnedToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :returned, :boolean, default: false
  end
end

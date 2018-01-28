class AddSuspendedToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :suspended, :boolean, default: false
    add_column :registrations, :comment, :string, limit: 150
  end
end

class AddSchooltermidToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :schoolterm_id, :integer
  end
end

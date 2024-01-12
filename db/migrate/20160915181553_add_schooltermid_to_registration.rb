class AddSchooltermidToRegistration < ActiveRecord::Migration[4.2]
  def change
    add_column :registrations, :schoolterm_id, :integer
  end
end

class AddWithdrawnToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :withdrawn, :boolean, default: false
  end
end

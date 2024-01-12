class AddWithdrawnToRegistration < ActiveRecord::Migration[4.2]
  def change
    add_column :registrations, :withdrawn, :boolean, default: false
  end
end

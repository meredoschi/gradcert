class AddFinalgradeToRegistration < ActiveRecord::Migration[4.2]
  def change
    add_column :registrations, :finalgrade, :float, default: 0.00
  end
end

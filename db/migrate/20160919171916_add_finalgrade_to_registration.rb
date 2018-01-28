class AddFinalgradeToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :finalgrade, :float, default: 0.00
  end
end

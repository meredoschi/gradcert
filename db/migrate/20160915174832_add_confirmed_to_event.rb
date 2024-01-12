class AddConfirmedToEvent < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :confirmed, :boolean, default: false
  end
end

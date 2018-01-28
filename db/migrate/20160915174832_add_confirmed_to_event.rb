class AddConfirmedToEvent < ActiveRecord::Migration
  def change
    add_column :events, :confirmed, :boolean, default: false
  end
end

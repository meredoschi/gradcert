class AddConfirmedToContact < ActiveRecord::Migration[4.2]
  def change
    add_column :contacts, :confirmed, :boolean, default: :false
  end
end

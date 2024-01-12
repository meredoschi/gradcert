class AddPapMedresToRegistration < ActiveRecord::Migration[4.2]
  def change
    add_column :registrations, :pap, :boolean, default: false
    add_column :registrations, :medres, :boolean, default: false
  end
end

class AddPapMedresToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :pap, :boolean, default: false
    add_column :registrations, :medres, :boolean, default: false
  end
end

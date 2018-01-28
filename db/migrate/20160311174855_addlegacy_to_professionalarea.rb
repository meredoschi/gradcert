class AddlegacyToProfessionalarea < ActiveRecord::Migration
  def change
    add_column :professionalareas, :legacy, :boolean, default: false
  end
end

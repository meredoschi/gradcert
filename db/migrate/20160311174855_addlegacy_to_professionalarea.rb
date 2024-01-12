class AddlegacyToProfessionalarea < ActiveRecord::Migration[4.2]
  def change
    add_column :professionalareas, :legacy, :boolean, default: false
  end
end

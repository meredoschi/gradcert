class AddPreviousnameToProfessionalarea < ActiveRecord::Migration[4.2]
  def change
    add_column :professionalareas, :previousname, :string, limit: 150
  end
end

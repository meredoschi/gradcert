class AddPreviousnameToProfessionalarea < ActiveRecord::Migration
  def change
    add_column :professionalareas, :previousname, :string, limit: 150
  end
end

class AddPapMedresToProfessionalarea < ActiveRecord::Migration
  def change
    add_column :professionalareas, :pap, :boolean, default: false
    add_column :professionalareas, :medres, :boolean, default: false
  end
end

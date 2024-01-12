class AddPapMedresToTaxation < ActiveRecord::Migration[4.2]
  def change
    add_column :taxations, :pap, :boolean, default: false
    add_column :taxations, :medres, :boolean, default: false
  end
end

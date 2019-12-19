class RemovePapMedresFromInstitutions < ActiveRecord::Migration
  def change
    remove_column :institutions, :pap, :boolean
    remove_column :institutions, :medres, :boolean
  end
end

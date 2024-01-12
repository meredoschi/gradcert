class RemovePapMedresFromInstitutions < ActiveRecord::Migration[4.2]
  def change
    remove_column :institutions, :pap, :boolean
    remove_column :institutions, :medres, :boolean
  end
end

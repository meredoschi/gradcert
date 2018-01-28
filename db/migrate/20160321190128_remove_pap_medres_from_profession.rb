class RemovePapMedresFromProfession < ActiveRecord::Migration
  def change
    change_table :professions do |t|
      t.remove :pap
      t.remove :medres
    end
  end
end

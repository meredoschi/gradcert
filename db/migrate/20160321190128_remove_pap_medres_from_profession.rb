class RemovePapMedresFromProfession < ActiveRecord::Migration[4.2]
  def change
    change_table :professions do |t|
      t.remove :pap
      t.remove :medres
    end
  end
end

class AddPapMedresToProfessions < ActiveRecord::Migration[4.2]
  def change
    add_column :professions, :pap, :boolean, default: false
    add_column :professions, :medres, :boolean, default: false
  end
end

class AddPapMedresToDegreetype < ActiveRecord::Migration[4.2]
  def change
    add_column :degreetypes, :pap, :boolean, default: false
    add_column :degreetypes, :medres, :boolean, default: false
  end
end

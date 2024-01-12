class AddFavorableToProgramsituation < ActiveRecord::Migration[4.2]
  def change
    add_column :programsituations, :favorable, :boolean, default: false
  end
end

class AddFavorableToProgramsituation < ActiveRecord::Migration
  def change
    add_column :programsituations, :favorable, :boolean, default: false
  end
end

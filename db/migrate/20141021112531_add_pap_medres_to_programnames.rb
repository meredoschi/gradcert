class AddPapMedresToProgramnames < ActiveRecord::Migration
  def change
    add_column :programnames, :pap, :boolean, default: false
    add_column :programnames, :medres, :boolean, default: false
  end
end

class AddPapMedresToProgramnames < ActiveRecord::Migration[4.2]
  def change
    add_column :programnames, :pap, :boolean, default: false
    add_column :programnames, :medres, :boolean, default: false
  end
end

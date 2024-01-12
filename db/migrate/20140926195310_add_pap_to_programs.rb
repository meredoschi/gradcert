class AddPapToPrograms < ActiveRecord::Migration[4.2]
  def change
    add_column :programs, :pap, :boolean, default: false
  end
end

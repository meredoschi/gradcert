class AddPapToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :pap, :boolean, default: false
  end
end

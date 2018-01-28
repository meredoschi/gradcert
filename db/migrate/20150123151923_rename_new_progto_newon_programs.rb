class RenameNewProgtoNewonPrograms < ActiveRecord::Migration
  def change
    change_table :programs do |t|
      t.rename :newprog, :new
    end
  end
end

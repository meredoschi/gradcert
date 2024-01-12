class RenameNewProgtoNewonPrograms < ActiveRecord::Migration[4.2]
  def change
    change_table :programs do |t|
      t.rename :newprog, :new
    end
  end
end

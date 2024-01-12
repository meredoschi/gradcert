class RemoveOldProgramCols < ActiveRecord::Migration[4.2]
  def change
    change_table :programs do |t|
      t.remove :programnum
      t.remove :instprogramnum
    end
  end
end

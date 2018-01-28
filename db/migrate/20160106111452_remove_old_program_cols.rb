class RemoveOldProgramCols < ActiveRecord::Migration
  def change
    change_table :programs do |t|
      t.remove :programnum
      t.remove :instprogramnum
    end
  end
end

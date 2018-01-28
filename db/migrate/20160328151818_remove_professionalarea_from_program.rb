class RemoveProfessionalareaFromProgram < ActiveRecord::Migration
  def change
    change_table :programs do |t|
      t.remove :professionalarea_id
    end
  end
end

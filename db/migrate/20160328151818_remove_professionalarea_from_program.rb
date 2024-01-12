class RemoveProfessionalareaFromProgram < ActiveRecord::Migration[4.2]
  def change
    change_table :programs do |t|
      t.remove :professionalarea_id
    end
  end
end

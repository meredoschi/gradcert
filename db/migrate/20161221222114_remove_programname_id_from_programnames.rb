class RemoveProgramnameIdFromProgramnames < ActiveRecord::Migration
  def change
    change_table :programnames do |t|
      t.remove :programname_id
    end
  end
end

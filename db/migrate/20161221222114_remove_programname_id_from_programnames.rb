class RemoveProgramnameIdFromProgramnames < ActiveRecord::Migration[4.2]
  def change
    change_table :programnames do |t|
      t.remove :programname_id
    end
  end
end

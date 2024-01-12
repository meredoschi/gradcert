class FixSelfJoinIdForProgramname < ActiveRecord::Migration[4.2]
  def change
    change_table :programnames do |t|
      t.remove :parentid
    end
    add_column :programnames, :programname_id, :integer
  end
end

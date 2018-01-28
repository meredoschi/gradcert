class FixSelfJoinIdForProgramname < ActiveRecord::Migration
  def change
    change_table :programnames do |t|
      t.remove :parentid
    end
    add_column :programnames, :programname_id, :integer
  end
end

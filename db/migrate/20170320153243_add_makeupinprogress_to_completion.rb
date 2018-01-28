class AddMakeupinprogressToCompletion < ActiveRecord::Migration
  def change
    add_column :completions, :makeupinprogress, :boolean
  end
end

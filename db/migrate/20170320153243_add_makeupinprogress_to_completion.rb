class AddMakeupinprogressToCompletion < ActiveRecord::Migration[4.2]
  def change
    add_column :completions, :makeupinprogress, :boolean
  end
end

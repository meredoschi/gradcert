class RenameFailToFailureOnCompletion < ActiveRecord::Migration
  def change
    change_table :completions do |t|
      t.rename :fail, :failure
    end
  end
end

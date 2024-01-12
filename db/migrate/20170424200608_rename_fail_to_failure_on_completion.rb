class RenameFailToFailureOnCompletion < ActiveRecord::Migration[4.2]
  def change
    change_table :completions do |t|
      t.rename :fail, :failure
    end
  end
end

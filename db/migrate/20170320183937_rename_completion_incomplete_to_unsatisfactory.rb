class RenameCompletionIncompleteToUnsatisfactory < ActiveRecord::Migration[4.2]
  def change
    change_table :completions do |t|
      t.rename :incomplete, :unsatisfactory
    end
  end
end

class RenameCompletionIncompleteToUnsatisfactory < ActiveRecord::Migration
  def change
    change_table :completions do |t|
      t.rename :incomplete, :unsatisfactory
    end
  end
end

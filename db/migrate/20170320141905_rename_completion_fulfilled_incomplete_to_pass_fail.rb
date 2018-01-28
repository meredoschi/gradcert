class RenameCompletionFulfilledIncompleteToPassFail < ActiveRecord::Migration
  def change
    change_table :completions do |t|
      t.rename :fulfilled, :pass
      t.rename :incomplete, :fail
    end
  end
end

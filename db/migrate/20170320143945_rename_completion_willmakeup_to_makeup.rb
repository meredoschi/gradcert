class RenameCompletionWillmakeupToMakeup < ActiveRecord::Migration[4.2]
  def change
    change_table :completions do |t|
      t.rename :willmakeup, :makeup
    end
  end
end

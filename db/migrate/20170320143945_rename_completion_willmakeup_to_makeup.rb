class RenameCompletionWillmakeupToMakeup < ActiveRecord::Migration
  def change
    change_table :completions do |t|
      t.rename :willmakeup, :makeup
    end
  end
end

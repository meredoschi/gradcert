class StreamlineCompletion < ActiveRecord::Migration
  def change
    change_table :completions do |t|
      t.rename :makeup, :mustmakeup
      t.remove :makeupinprogress
      t.remove :madeup
      t.remove :unsatisfactory
    end
  end
end

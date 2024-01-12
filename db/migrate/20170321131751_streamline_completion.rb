class StreamlineCompletion < ActiveRecord::Migration[4.2]
  def change
    change_table :completions do |t|
      t.rename :makeup, :mustmakeup
      t.remove :makeupinprogress
      t.remove :madeup
      t.remove :unsatisfactory
    end
  end
end

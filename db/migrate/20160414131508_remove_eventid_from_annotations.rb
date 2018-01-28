class RemoveEventidFromAnnotations < ActiveRecord::Migration
  def change
    change_table :annotations do |t|
      t.remove :event_id
    end
  end
end

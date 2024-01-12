class RemoveEventidFromAnnotations < ActiveRecord::Migration[4.2]
  def change
    change_table :annotations do |t|
      t.remove :event_id
    end
  end
end

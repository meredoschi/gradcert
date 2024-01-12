class AddEventidToAnnotation < ActiveRecord::Migration[4.2]
  def change
    add_column :annotations, :event_id, :integer
  end
end

class AddEventidToAnnotation < ActiveRecord::Migration
  def change
    add_column :annotations, :event_id, :integer
  end
end

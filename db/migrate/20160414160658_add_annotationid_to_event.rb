class AddAnnotationidToEvent < ActiveRecord::Migration
  def change
    add_column :events, :annotation_id, :integer
  end
end

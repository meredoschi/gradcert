class AddAnnotationidToEvent < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :annotation_id, :integer
  end
end

class AddAutomaticToAnnotation < ActiveRecord::Migration[4.2]
  def change
    add_column :annotations, :automatic, :boolean, default: false
  end
end

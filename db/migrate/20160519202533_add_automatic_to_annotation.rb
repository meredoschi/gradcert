class AddAutomaticToAnnotation < ActiveRecord::Migration
  def change
    add_column :annotations, :automatic, :boolean, default: false
  end
end

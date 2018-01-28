class AddConfirmedToAnnotation < ActiveRecord::Migration
  def change
    add_column :annotations, :confirmed, :boolean, default: false
  end
end

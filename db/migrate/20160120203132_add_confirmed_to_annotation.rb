class AddConfirmedToAnnotation < ActiveRecord::Migration[4.2]
  def change
    add_column :annotations, :confirmed, :boolean, default: false
  end
end

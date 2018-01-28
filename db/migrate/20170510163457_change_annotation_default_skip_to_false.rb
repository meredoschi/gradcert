class ChangeAnnotationDefaultSkipToFalse < ActiveRecord::Migration
  def change
    change_column_default :annotations, :skip, false
  end
end

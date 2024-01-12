class ChangeAnnotationDefaultSkipToFalse < ActiveRecord::Migration[4.2]
  def change
    change_column_default :annotations, :skip, false
  end
end

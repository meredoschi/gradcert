class RemoveIntegerFromAnnotation < ActiveRecord::Migration
  def change
    change_table :annotations do |t|
      t.remove :integer
    end
  end
end

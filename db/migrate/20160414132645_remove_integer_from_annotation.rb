class RemoveIntegerFromAnnotation < ActiveRecord::Migration[4.2]
  def change
    change_table :annotations do |t|
      t.remove :integer
    end
  end
end

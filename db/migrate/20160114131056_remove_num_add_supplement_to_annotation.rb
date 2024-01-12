class RemoveNumAddSupplementToAnnotation < ActiveRecord::Migration[4.2]
  def change
    change_table :annotations do |t|
      t.remove :num
    end
    add_column :annotations, :supplement, :integer
  end
end

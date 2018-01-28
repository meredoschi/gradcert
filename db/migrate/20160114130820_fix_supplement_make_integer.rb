class FixSupplementMakeInteger < ActiveRecord::Migration
  def change
    change_table :annotations do |t|
      t.remove :supplement
    end
    add_column :annotations, :num, :integer
  end
end

class AddProcessedRemoveMissed < ActiveRecord::Migration
  def change
    change_table :feedbacks do |t|
      t.remove :missed
    end
    add_column :feedbacks, :processed, :boolean, default: true
   end
end

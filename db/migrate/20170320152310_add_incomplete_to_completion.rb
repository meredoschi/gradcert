class AddIncompleteToCompletion < ActiveRecord::Migration
  def change
    add_column :completions, :incomplete, :boolean, default: :false
  end
end

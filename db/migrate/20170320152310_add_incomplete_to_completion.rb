class AddIncompleteToCompletion < ActiveRecord::Migration[4.2]
  def change
    add_column :completions, :incomplete, :boolean, default: :false
  end
end

class AddSchooltermIdToStudent < ActiveRecord::Migration
  def change
    add_column :students, :schoolterm_id, :integer
    add_index :students, :schoolterm_id
  end
end

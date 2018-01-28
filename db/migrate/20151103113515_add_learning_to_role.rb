class AddLearningToRole < ActiveRecord::Migration
  def change
    add_column :roles, :learning, :boolean, default: false
  end
end

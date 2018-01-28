class AddResidualToEvent < ActiveRecord::Migration
  def change
    add_column :events, :residual, :boolean, default: false
  end
end

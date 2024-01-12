class AddResidualToEvent < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :residual, :boolean, default: false
  end
end

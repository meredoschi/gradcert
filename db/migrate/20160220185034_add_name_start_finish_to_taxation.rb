class AddNameStartFinishToTaxation < ActiveRecord::Migration[4.2]
  def change
    add_column :taxations, :name, :string, limit: 150
    add_column :taxations, :start, :date
    add_column :taxations, :finish, :date
  end
end

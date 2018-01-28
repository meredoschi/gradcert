class AddCapitalToMunicipality < ActiveRecord::Migration
  def change
    add_column :municipalities, :capital, :boolean, default: false
  end
end

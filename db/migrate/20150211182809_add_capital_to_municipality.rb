class AddCapitalToMunicipality < ActiveRecord::Migration[4.2]
  def change
    add_column :municipalities, :capital, :boolean, default: false
  end
end

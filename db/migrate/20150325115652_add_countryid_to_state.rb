class AddCountryidToState < ActiveRecord::Migration[4.2]
  def change
    add_column :states, :country_id, :integer
  end
end

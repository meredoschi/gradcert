class AddCodmuniToMunicipalities < ActiveRecord::Migration[4.2]
  def change
    add_column :municipalities, :codmuni, :integer
  end
end

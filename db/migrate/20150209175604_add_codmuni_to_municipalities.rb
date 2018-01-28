class AddCodmuniToMunicipalities < ActiveRecord::Migration
  def change
    add_column :municipalities, :codmuni, :integer
  end
end

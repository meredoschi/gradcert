class IncreaseNameSizeOnProfessions < ActiveRecord::Migration[4.2]
  def change
    change_column :professions, :name, :string, limit: 150
  end
end

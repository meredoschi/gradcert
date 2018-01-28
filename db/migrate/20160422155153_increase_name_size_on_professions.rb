class IncreaseNameSizeOnProfessions < ActiveRecord::Migration
  def change
    change_column :professions, :name, :string, limit: 150
  end
end

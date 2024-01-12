class IncreaseNameSizeOnProfessionalfamily < ActiveRecord::Migration[4.2]
  def change
    change_column :professionalfamilies, :name, :string, limit: 150
  end
end

class IncreaseNameSizeOnProfessionalfamily < ActiveRecord::Migration
  def change
    change_column :professionalfamilies, :name, :string, limit: 150
  end
end

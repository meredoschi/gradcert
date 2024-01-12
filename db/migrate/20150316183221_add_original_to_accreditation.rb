class AddOriginalToAccreditation < ActiveRecord::Migration[4.2]
  def change
    add_column :accreditations, :original, :boolean, default: false
  end
end

class AddOriginalToAccreditation < ActiveRecord::Migration
  def change
    add_column :accreditations, :original, :boolean, default: false
  end
end

class RemoveCurrentFromAccreditations < ActiveRecord::Migration[4.2]
  def change
    remove_column :accreditations, :current
  end
end

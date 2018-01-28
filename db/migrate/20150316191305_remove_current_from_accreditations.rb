class RemoveCurrentFromAccreditations < ActiveRecord::Migration
  def change
    remove_column :accreditations, :current
  end
end

class AddRenewedToAccreditation < ActiveRecord::Migration
  def change
    add_column :accreditations, :renewed, :boolean, default: false
  end
end

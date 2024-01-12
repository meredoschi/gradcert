class AddRenewedToAccreditation < ActiveRecord::Migration[4.2]
  def change
    add_column :accreditations, :renewed, :boolean, default: false
  end
end

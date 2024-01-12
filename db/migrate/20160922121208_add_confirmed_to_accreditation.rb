class AddConfirmedToAccreditation < ActiveRecord::Migration[4.2]
  def change
    add_column :accreditations, :confirmed, :boolean, default: false
  end
end

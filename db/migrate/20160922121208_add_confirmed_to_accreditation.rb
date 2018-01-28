class AddConfirmedToAccreditation < ActiveRecord::Migration
  def change
    add_column :accreditations, :confirmed, :boolean, default: false
  end
end

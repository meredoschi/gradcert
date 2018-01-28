class AddSuspendedToAccreditation < ActiveRecord::Migration
  def change
    add_column :accreditations, :suspension, :date
    add_column :accreditations, :suspended, :boolean
  end
end

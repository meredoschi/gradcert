class AddSuspendedToAccreditation < ActiveRecord::Migration[4.2]
  def change
    add_column :accreditations, :suspension, :date
    add_column :accreditations, :suspended, :boolean
  end
end

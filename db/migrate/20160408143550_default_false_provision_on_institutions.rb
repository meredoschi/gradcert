class DefaultFalseProvisionOnInstitutions < ActiveRecord::Migration[4.2]
  def change
    change_column :institutions, :provisional, :boolean, default: false
  end
end

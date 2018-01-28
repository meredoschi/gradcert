class DefaultFalseProvisionOnInstitutions < ActiveRecord::Migration
  def change
    change_column :institutions, :provisional, :boolean, default: false
  end
end

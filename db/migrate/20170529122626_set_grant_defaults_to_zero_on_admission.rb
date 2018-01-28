class SetGrantDefaultsToZeroOnAdmission < ActiveRecord::Migration
  def change
    change_column :admissions, :accreditedgrants, :integer, default: 0, null: false
    change_column :admissions, :grantsasked, :integer, default: 0, null: false
    change_column :admissions, :grantsgiven, :integer, default: 0, null: false
  end
end

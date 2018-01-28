class ChangeTaxationSocialSecurityToDecimal < ActiveRecord::Migration
  def change
    change_column :taxations, :socialsecurity, :decimal, precision: 5, scale: 2
  end
end

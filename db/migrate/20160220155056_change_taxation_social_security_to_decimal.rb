class ChangeTaxationSocialSecurityToDecimal < ActiveRecord::Migration[4.2]
  def change
    change_column :taxations, :socialsecurity, :decimal, precision: 5, scale: 2
  end
end

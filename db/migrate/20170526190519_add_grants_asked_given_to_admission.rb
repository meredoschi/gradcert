class AddGrantsAskedGivenToAdmission < ActiveRecord::Migration[4.2]
  def change
    add_column :admissions, :grantsasked, :integer
    add_column :admissions, :grantsgiven, :integer
  end
end

class AddGrantsAskedGivenToAdmission < ActiveRecord::Migration
  def change
    add_column :admissions, :grantsasked, :integer
    add_column :admissions, :grantsgiven, :integer
  end
end

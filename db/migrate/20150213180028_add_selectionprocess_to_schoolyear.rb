class AddSelectionprocessToSchoolyear < ActiveRecord::Migration[4.2]
  def change
    add_column :schoolyears, :candidates, :integer
    add_column :schoolyears, :approved, :integer
    add_column :schoolyears, :grantsrequested, :integer
    add_column :schoolyears, :convokedtoregister, :integer
  end
end

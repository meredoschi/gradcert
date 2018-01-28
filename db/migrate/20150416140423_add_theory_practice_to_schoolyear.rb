class AddTheoryPracticeToSchoolyear < ActiveRecord::Migration
  def change
    add_column :schoolyears, :theory, :integer
    add_column :schoolyears, :practice, :integer
  end
end

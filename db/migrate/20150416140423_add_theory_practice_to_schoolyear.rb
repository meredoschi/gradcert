class AddTheoryPracticeToSchoolyear < ActiveRecord::Migration[4.2]
  def change
    add_column :schoolyears, :theory, :integer
    add_column :schoolyears, :practice, :integer
  end
end

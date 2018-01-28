class AddStartdayFinishdayToScholarship < ActiveRecord::Migration
  def change
    add_column :scholarships, :startday, :integer, default: 0
    add_column :scholarships, :finishday, :integer, default: 0
  end
end

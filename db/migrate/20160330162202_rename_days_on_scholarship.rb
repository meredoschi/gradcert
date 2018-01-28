class RenameDaysOnScholarship < ActiveRecord::Migration
  def change
    change_table :scholarships do |t|
      t.rename :startday, :daystarted
      t.rename :finishday, :dayfinished
    end
  end
end

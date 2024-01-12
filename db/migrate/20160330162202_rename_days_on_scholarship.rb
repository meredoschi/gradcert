class RenameDaysOnScholarship < ActiveRecord::Migration[4.2]
  def change
    change_table :scholarships do |t|
      t.rename :startday, :daystarted
      t.rename :finishday, :dayfinished
    end
  end
end

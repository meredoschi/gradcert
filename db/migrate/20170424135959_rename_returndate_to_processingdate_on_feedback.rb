class RenameReturndateToProcessingdateOnFeedback < ActiveRecord::Migration
  def change
    change_table :feedbacks do |t|
      t.rename :returndate, :processingdate
    end
  end
end

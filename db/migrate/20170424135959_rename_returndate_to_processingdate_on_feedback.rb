class RenameReturndateToProcessingdateOnFeedback < ActiveRecord::Migration[4.2]
  def change
    change_table :feedbacks do |t|
      t.rename :returndate, :processingdate
    end
  end
end

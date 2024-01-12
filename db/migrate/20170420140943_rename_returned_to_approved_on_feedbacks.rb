class RenameReturnedToApprovedOnFeedbacks < ActiveRecord::Migration[4.2]
  def change
    change_table :feedbacks do |t|
      t.rename :returned, :approved
    end
  end
end

class RenameReturnedToApprovedOnFeedbacks < ActiveRecord::Migration
  def change
    change_table :feedbacks do |t|
      t.rename :returned, :approved
    end
  end
end

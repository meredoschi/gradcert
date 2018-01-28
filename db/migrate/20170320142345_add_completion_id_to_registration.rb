class AddCompletionIdToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :completion_id, :integer
  end
end

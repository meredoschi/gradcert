class AddCompletionIdToRegistration < ActiveRecord::Migration[4.2]
  def change
    add_column :registrations, :completion_id, :integer
  end
end

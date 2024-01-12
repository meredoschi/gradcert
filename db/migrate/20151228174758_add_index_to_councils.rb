class AddIndexToCouncils < ActiveRecord::Migration[4.2]
  def change
    add_index :councils, %i[name state_id]
  end
end

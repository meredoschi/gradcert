class AddIndexToCouncils < ActiveRecord::Migration
  def change
    add_index :councils, %i[name state_id]
  end
end

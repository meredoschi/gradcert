class RemoveSchooltermidFromRegistration < ActiveRecord::Migration[4.2]
  def change
    change_table :registrations do |t|
      t.remove :schoolterm_id
    end
    end
end

class RemoveSchooltermidFromRegistration < ActiveRecord::Migration
  def change
    change_table :registrations do |t|
      t.remove :schoolterm_id
    end
    end
end

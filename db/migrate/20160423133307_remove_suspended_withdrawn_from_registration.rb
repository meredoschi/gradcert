class RemoveSuspendedWithdrawnFromRegistration < ActiveRecord::Migration
  def change
    change_table :registrations do |t|
      t.remove :suspended
      t.remove :withdrawn
    end
  end
end

class RemoveSuspendedWithdrawnFromRegistration < ActiveRecord::Migration[4.2]
  def change
    change_table :registrations do |t|
      t.remove :suspended
      t.remove :withdrawn
    end
  end
end

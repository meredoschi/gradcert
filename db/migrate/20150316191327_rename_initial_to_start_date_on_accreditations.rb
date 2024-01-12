class RenameInitialToStartDateOnAccreditations < ActiveRecord::Migration[4.2]
  def change
    change_table :accreditations do |t|
      t.rename :initial, :start_date
    end
  end
end

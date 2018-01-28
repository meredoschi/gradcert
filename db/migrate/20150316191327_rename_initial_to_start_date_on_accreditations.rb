class RenameInitialToStartDateOnAccreditations < ActiveRecord::Migration
  def change
    change_table :accreditations do |t|
      t.rename :initial, :start_date
    end
  end
end

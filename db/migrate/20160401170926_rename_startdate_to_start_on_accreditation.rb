class RenameStartdateToStartOnAccreditation < ActiveRecord::Migration[4.2]
  def change
    change_table :accreditations do |t|
      t.rename :start_date, :start
    end
  end
end

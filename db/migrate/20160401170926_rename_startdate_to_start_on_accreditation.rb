class RenameStartdateToStartOnAccreditation < ActiveRecord::Migration
  def change
    change_table :accreditations do |t|
      t.rename :start_date, :start
    end
  end
end

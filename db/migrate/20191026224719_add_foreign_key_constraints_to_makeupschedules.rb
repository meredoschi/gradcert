class AddForeignKeyConstraintsToMakeupschedules < ActiveRecord::Migration
  def change
    add_foreign_key :makeupschedules, :registrations
  end
end

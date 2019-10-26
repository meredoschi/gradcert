class AddForeignKeyConstraintsToEvents < ActiveRecord::Migration
  def change
    add_foreign_key :events, :annotations
    add_foreign_key :events, :leavetypes
    add_foreign_key :events, :registrations
  end
end

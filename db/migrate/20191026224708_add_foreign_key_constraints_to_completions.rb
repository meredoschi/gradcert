class AddForeignKeyConstraintsToCompletions < ActiveRecord::Migration
  def change
    add_foreign_key :completions, :registrations
  end
end

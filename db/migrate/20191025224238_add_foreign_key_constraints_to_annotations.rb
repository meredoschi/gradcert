class AddForeignKeyConstraintsToAnnotations < ActiveRecord::Migration
  def change
    add_foreign_key :annotations, :payrolls
    add_foreign_key :annotations, :registrations
  end
end

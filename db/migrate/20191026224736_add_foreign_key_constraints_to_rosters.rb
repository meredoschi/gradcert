class AddForeignKeyConstraintsToRosters < ActiveRecord::Migration
  def change
    add_foreign_key :rosters, :institutions
    add_foreign_key :rosters, :schoolterms
  end
end

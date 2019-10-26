class AddForeignKeyConstraintsToResearchcenters < ActiveRecord::Migration
  def change
    add_foreign_key :researchcenters, :institutions
  end
end

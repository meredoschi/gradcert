class AddForeignKeyConstraintsToRecommendations < ActiveRecord::Migration
  def change
    add_foreign_key :recommendations, :programsituations
  end
end

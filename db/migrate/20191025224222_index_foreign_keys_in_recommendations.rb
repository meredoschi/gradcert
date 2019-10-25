class IndexForeignKeysInRecommendations < ActiveRecord::Migration
  def change
    add_index :recommendations, :programsituation_id
  end
end

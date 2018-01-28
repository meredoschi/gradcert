class AddProgramyearToRecommendations < ActiveRecord::Migration
  def change
    add_column :recommendations, :programyear, :integer
  end
end

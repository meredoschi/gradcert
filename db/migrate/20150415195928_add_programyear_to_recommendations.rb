class AddProgramyearToRecommendations < ActiveRecord::Migration[4.2]
  def change
    add_column :recommendations, :programyear, :integer
  end
end

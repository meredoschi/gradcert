class CreateRecommendations < ActiveRecord::Migration[4.2]
  def change
    create_table :recommendations do |t|
      t.integer :programsituation_id
      t.integer :grants
      t.integer :theory
      t.integer :practice

      t.timestamps
    end
  end
end

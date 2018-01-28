# In Brazil, this subdivision is used for statistical and planning purposes only.
class Stateregion < ActiveRecord::Base
  belongs_to :state

  has_many  :municipality, foreign_key: 'stateregion_id'

  has_many  :characteristic, foreign_key: 'stateregion_id'

  # RSPEC  start
  validates :name, presence: true, length: { maximum: 50 }
  # Tested code finish
  def self.paulista
    joins(:state).where(states: { abbreviation: 'SP' })
  end
end

# frozen_string_literal: true

# In Brazil, this subdivision is used for statistical and planning purposes only.
class Stateregion < ActiveRecord::Base
  belongs_to :state

  has_many :municipality, foreign_key: 'stateregion_id',
                          dependent: :delete_all, inverse_of: :stateregion

  scope :paulista, -> { joins(:state).where(states: { abbreviation: 'SP' }) }

  # Applicable to Brazil only
  validates :name, presence: true, length: { maximum: 50 }
end

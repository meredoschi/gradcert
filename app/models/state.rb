# frozen_string_literal: true

# Highest subnational division
class State < ActiveRecord::Base
  #   has_many  :municipality, :foreign_key => 'brstate_id'
  has_many  :stateregion, foreign_key: 'state_id',
                          dependent: :restrict_with_exception, inverse_of: :state
  has_many  :personalinfo, foreign_key: 'state_id',
                           dependent: :restrict_with_exception, inverse_of: :state

  has_many :council, foreign_key: 'state_id',
                     dependent: :restrict_with_exception, inverse_of: :state

  def self.default_scope
    order(name: :asc)
  end

  scope :sp, -> {
               where(abbreviation: 'SP')
             }

  scope :home, -> {
                 where(abbreviation: Settings.home_state_abbreviation)
               }

  def self.domestic
    joins(:country).merge(Country.domestic)
  end

  def self.foreign
    joins(:country).merge(Country.foreign)
  end

  # RSPEC start
  validates :name, presence: true, length:  { maximum: 80 }
  validates :abbreviation, presence: true,  length: { maximum: 10 }
  # Tested code finish
end

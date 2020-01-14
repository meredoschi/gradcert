# frozen_string_literal: true

# Municipality names seldom change
class Municipality < ActiveRecord::Base
  belongs_to :stateregion
  belongs_to :regionaloffice

  has_many :address, foreign_key: 'municipality_id',
                     dependent: :restrict_with_exception, inverse_of: :municipality

  scope :paulista, -> { joins(:stateregion).merge(Stateregion.paulista).order(:name) }

  scope :with_address, -> { joins(:address) }

  scope :with_institution, -> { joins(:address).merge(Address.institution).order(:name) }

  scope :from_home_state, -> {
                            joins(stateregion: :state).where('states.abbreviation = ? ',
                                                             Settings.home_state_abbreviation)
                          }

  # validates_uniqueness_of :name, :scope => [:mesoregion_id]

  scope :hometown, -> {
                     find_by asciinamewithstate: I18n
                       .t('definitions.municipality.default.asciinamewithstate')
                   }
  #    I18n.t('definitions.municipality.default.asciinamewithstate').first }

  # To do: order by state as well
  scope  :with_institution_ordered_by_name, -> { with_institution.uniq.order(:name) }

  scope  :ordered_by_asciiname_and_state, -> { order(asciinamewithstate: :asc) }
  # joins(stateregion: :state).order(:asciiname, "states.abbreviation")

  scope :from_home_state, -> {
                            joins(stateregion: :state).where('states.abbreviation = ? ',
                                                             Settings.home_state_abbreviation)
                          }

  validates :name, presence: true, length: { maximum: 70 }

  # Returns state abbreviation based on denormalized table (created by the rake task)
  def stateabbreviation
    #       stateregion.state.abbreviation
    asciinamewithstate.split(' / ')[1]
  end

  def institution_count
    address.institution.count
  end

  # http://stackoverflow.com/questions/3784394/rails-3-combine-two-variables
  def name_with_state
    #  [name, " - ", self.stateregion.state.abbreviation].join(" ")

    # Faster: implemented as a database column
    namewithstate
  end

  def city
    #      [name, self.stateregion.state.abbreviation] .join(" - ")

    name

    # [address, addresscomplement].join(" ")
  end

  # Name without accents
  def nameplain
    I18n.transliterate(name)
  end

  #  def self.default_scope

  #     self.ordered_by_asciiname_and_state

  #  end
end

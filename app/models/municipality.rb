# Municipality names seldom change
class Municipality < ActiveRecord::Base
  belongs_to :stateregion
  belongs_to :regionaloffice

  has_many  :personalinfo, foreign_key: 'municipality_id'

  has_many  :institution, foreign_key: 'municipality_id'
  has_many  :contact, foreign_key: 'municipality_id'

  has_many  :address, foreign_key: 'municipality_id'

  scope :paulista, -> { joins(:stateregion).merge(Stateregion.paulista).order(:name) }

  scope :with_address, -> { joins(:address) }

  scope :with_institution, -> { joins(:address).merge(Address.institution).order(:name) }

  # RSPEC start

  validates :name, presence: true, length: { maximum: 70 }

  #  Tested code finish

  # Instance methods

  # Returns state abbreviation based on denormalized table (created by the rake task)
  def stateabbreviation
    # 		  stateregion.state.abbreviation
    asciinamewithstate.split(' / ')[1]
  end

  #

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
    # 	   [name, self.stateregion.state.abbreviation] .join(" - ")

    name

    # [address, addresscomplement].join(" ")
  end

  # Name without accents
  def nameplain
    I18n.transliterate(name)
  end

  # validates_uniqueness_of :name, :scope => [:mesoregion_id]

  def self.hometown
    where('asciinamewithstate = ? ', Settings.default_municipality_ascii_name_with_state).first
  end

  # To do: order by state as well
  def self.with_institution_ordered_by_name
    with_institution.uniq.order(:name)
  end

  def self.ordered_by_asciiname_and_state
    # joins(stateregion: :state).order(:asciiname, "states.abbreviation")
    order(asciinamewithstate: :asc)
  end

  def self.from_home_state
    joins(stateregion: :state).where('states.abbreviation = ? ', Settings.home_state_abbreviation)
  end

  #  def self.default_scope

  #     self.ordered_by_asciiname_and_state

  #  end

  def self.with_institution
    joins(address: :institution)
  end
end

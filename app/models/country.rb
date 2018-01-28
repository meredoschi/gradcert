# ISO country list in "Brazilian Portuguese" and English
class Country < ActiveRecord::Base
  #  has_many  :address, :foreign_key => 'country_id'

  has_many :state, foreign_key: 'country_id'

  has_many :personalinfo, foreign_key: 'country_id'

  scope :domestic, -> { where(a3: Settings.home_country_abbreviation) }
  scope :foreign, -> { where.not(a3: Settings.home_country_abbreviation) }

  # RSPEC start

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 70 }
  validates :brname, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 70 }

  # Tested code finish

  # http://apidock.com/rails/ActiveRecord/Base/exists%3F/class

  def self.domestic?
    domestic.exists? # returns a boolean
  end

  def self.foreign?
    foreign.exists?
  end

  # i.e. has one or more states or provinces (subnational units) entered into the database
  # stateregion details entered for Brazil only

  def self.registered
    Country.joins(:state).uniq
  end

  def self.default_scope
    order(brname: :asc) # this notation prevents ambiguity
    # http://stackoverflow.com/questions/16896937/rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous
  end
end

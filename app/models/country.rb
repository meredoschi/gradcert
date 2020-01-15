# frozen_string_literal: true

# ISO country list in "Brazilian Portuguese" and English
class Country < ActiveRecord::Base
  #  has_many  :address, :foreign_key => 'country_id'

  # Used in contacts view with passport or registered foreigner ID to indicate originating country.
  # Assumed to be home country for those people with state IDs ("RG" in Brazil).
  has_many :personalinfo, foreign_key: 'country_id',
                          dependent: :restrict_with_exception, inverse_of: :country

  scope :domestic, -> { where(a3: Settings.home_country_abbreviation) }
  scope :foreign, -> { where.not(a3: Settings.home_country_abbreviation) }

  # RSPEC start

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 70 }
  validates :brname, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 70 }

  def domestic?
    a3 == Settings.home_country_abbreviation
  end

  def foreign?
    !domestic?
  end

  def self.default_scope
    order(brname: :asc) # this notation prevents ambiguity
    # http://stackoverflow.com/questions/16896937/rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous
  end
end

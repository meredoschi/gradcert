class Regionaloffice < ActiveRecord::Base
  has_one :address
  accepts_nested_attributes_for :address

  has_one :phone
  accepts_nested_attributes_for :phone

  has_one :webinfo
  accepts_nested_attributes_for :webinfo

  has_many  :municipality, foreign_key: 'regionaloffice_id'

  validates :num, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: Settings.max_number_regional_offices }, presence: true

  validates :directorsname, presence: true, length: { maximum: 120 }

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 100 }

  def self.with_institution
    joins(municipality: { address: :institution })
  end

  def self.default_scope
    # this notation prevents ambiguity
    order(name: :asc)
    # http://stackoverflow.com/questions/16896937/rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous
  end
end

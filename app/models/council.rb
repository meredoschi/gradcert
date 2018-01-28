class Council < ActiveRecord::Base
  has_one :address
  accepts_nested_attributes_for :address

  has_one :phone
  accepts_nested_attributes_for :phone

  has_one :webinfo
  accepts_nested_attributes_for :webinfo

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 150 }

  validates :abbreviation, uniqueness: { case_sensitive: false }, length: { maximum: 20 }

  validates :state_id, presence: true

  belongs_to :state

  has_many  :diploma, foreign_key: 'council_id'

  has_many  :professionalfamily, dependent: :destroy
  accepts_nested_attributes_for :professionalfamily, allow_destroy: true

  def self.default_scope
    # this notation prevents ambiguity
    order(name: :asc)
    # http://stackoverflow.com/questions/16896937/rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous
  end
end

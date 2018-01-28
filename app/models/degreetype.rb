class Degreetype < ActiveRecord::Base
  has_many :diploma, foreign_key: 'degreetype_id'

  # ********* It is assumed an attribute called 'name' exists for most models.  Adjust or comment accordingly ************************

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 100 }

  def self.default_scope
    # this notation prevents ambiguity
    order(name: :asc)
    # http://stackoverflow.com/questions/16896937/rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous
  end

  # http://api.rubyonrails.org/classes/ActiveRecord/Scoping/Named/ClassMethods.html
  scope :pap, -> { where(pap: true) }

  scope :medres, -> { where(medres: true) }

  # ***********************************************************************************************************************************
end

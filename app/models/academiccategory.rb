class Academiccategory < ActiveRecord::Base
  # ------------------- References ------------------------

  #	belongs_to :highered # Higher ed institution ("Instituição de Ensino Superior") - From the education ministry list

  has_many :school, foreign_key: 'school_id'

  # -------------------------------------------------------

  # ********* It is assumed an attribute called 'name' exists for most models.  Adjust or comment accordingly ************************

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 100 }

  def self.default_scope
    # this notation prevents ambiguity
    order(name: :asc)
    # http://stackoverflow.com/questions/16896937/rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous
  end

  # ***********************************************************************************************************************************
end

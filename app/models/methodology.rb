class Methodology < ActiveRecord::Base
  # ------------------- References ------------------------

  has_many  :course, foreign_key: 'methodology_id'

  # -------------------------------------------------------

  # ********* It is assumed an attribute called 'name' exists for most models.  Adjust or comment accordingly ************************

  validates :kind, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 120 }

  def self.default_scope
    # this notation prevents ambiguity
    order(kind: :asc)
    # http://stackoverflow.com/questions/16896937/rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous
  end

  # ***********************************************************************************************************************************
end

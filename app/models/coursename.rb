class Coursename < ActiveRecord::Base
  # ------------------- References ------------------------

  # 	belongs_to :user

  # 	has_many  :supervisor, :foreign_key => 'contact_id'

  # -------------------------------------------------------
  has_many  :course, foreign_key: 'coursename_id', dependent: :restrict_with_exception

  has_many  :diploma, foreign_key: 'coursename_id'

  # ********* It is assumed an attribute called 'name' exists for most models.  Adjust or comment accordingly ************************

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 200 }

  def self.default_scope
    # this notation prevents ambiguity
    order(name: :asc)
    # http://stackoverflow.com/questions/16896937/rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous
  end

  # ***********************************************************************************************************************************
end

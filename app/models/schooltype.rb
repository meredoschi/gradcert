class Schooltype < ActiveRecord::Base
  # ------------------- References ------------------------

  # 	belongs_to :user

  # 	has_many  :supervisor, :foreign_key => 'contact_id'

  # -------------------------------------------------------

  # ********* It is assumed an attribute called 'name' exists for most models.  Adjust or comment accordingly ************************

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 70 }

  def self.default_scope
    # this notation prevents ambiguity
    order(name: :asc)
    # http://stackoverflow.com/questions/16896937/rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous
  end

  # ***********************************************************************************************************************************
end

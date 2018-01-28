class School < ActiveRecord::Base
  # ------------------- References ------------------------

  belongs_to :academiccategory

  has_many :diploma, foreign_key: 'school_id'

  # 	has_many  :supervisor, :foreign_key => 'contact_id'

  # -------------------------------------------------------

  # ********* It is assumed an attribute called 'name' exists for most models.  Adjust or comment accordingly ************************

  validates_uniqueness_of :name, scope: [:ministrycode]

  validates :name, length: { maximum: 120 }

  def self.default_scope
    # this notation prevents ambiguity
    order(name: :asc)
    # http://stackoverflow.com/questions/16896937/rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous
  end

  # ***********************************************************************************************************************************
end

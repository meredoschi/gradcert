#  thing.rb
class Thing < ActiveRecord::Base
  # Replace with actual model name references, if applicable
  # ------------------- References ------------------------

  # 	belongs_to :parentmodel

  # 	has_many   :submodel, :foreign_key => 'submodel_id'

  # -------------------------------------------------------

  # It is assumed an attribute called 'name' exists on most models.  Adjust or comment accordingly.

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 200 }

  def self.default_scope
    order(name: :asc) # this notation prevents ambiguity
    # http://stackoverflow.com/questions/16896937/
    # rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous
  end
end

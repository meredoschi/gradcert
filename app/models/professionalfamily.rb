# CBO ("Brazilian Labor Ministry Official Classification")
class Professionalfamily < ActiveRecord::Base
  # ------------------- References ------------------------

  belongs_to :council

  has_many :course, foreign_key: 'professionalfamily_id'

  has_many  :profession, foreign_key: 'professionalfamily_id'

  # -------------------------------------------------------

  # --- Tested code start
  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 150 }
  # --- Tested code finish

  def self.default_scope
    # this notation prevents ambiguity
    order(name: :asc)
    # http://stackoverflow.com/questions/16896937/rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous
  end

  def self.pap
    where(pap: true)
  end

  def self.medres
    where(medres: true)
  end
end

# Useful statistic to have for course instruction
class Professionalarea < ActiveRecord::Base
  # ------------------- References ------------------------

  # 	belongs_to :user

  has_many :professionalspecialty, dependent: :restrict_with_exception

  # -------------------------------------------------------

  validates :name, presence: true, length: { maximum: 200 }

  validates_uniqueness_of :name

  def self.default_scope
    # this notation prevents ambiguity
    order(name: :asc)
    # http://stackoverflow.com/questions/16896937/rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous
  end

  def self.default_scope
    # this notation prevents ambiguity
    order(name: :asc)
    # http://stackoverflow.com/questions/16896937/rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous
  end

  def legacy?
    legacy
  end
end

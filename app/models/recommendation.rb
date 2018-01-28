class Recommendation < ActiveRecord::Base
  # ------------------- References ------------------------

  belongs_to :programsituation

  # 	has_many  :supervisor, :foreign_key => 'contact_id'

  # -------------------------------------------------------

  validates :programyear, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  # validates_uniqueness_of :programyear

  validate :programyear_consistency

  %i[theory practice].each do |h|
    validates h, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: Settings.total_hours_in_a_year }, presence: true
  end

  def self.default_scope
    # this notation prevents ambiguity
    order(programyear: :asc)
    # http://stackoverflow.com/questions/16896937/rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous
  end

  def programyear_consistency
    errors.add(:programyear, :inconsistent) if programyear > 3
  end

  def workload
    theory + practice
  end

  def self.default_scope
    order(programyear: :asc) # this notation prevents ambiguity
    # http://stackoverflow.com/questions/16896937/rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous
  end

  # Returns recommendations for a given program
  def self.for_program_situation(p)
    where(programsituation_id: p.id)
  end

  # Returns recommendations for a given year, for all programs
  def self.for_program_year(n)
    where(programyear: n)
  end

  def programyear_consistency; end
end

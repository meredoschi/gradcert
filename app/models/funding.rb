class Funding < ActiveRecord::Base
  belongs_to :characteristic

  # ------------------- References ------------------------

  # 	belongs_to :user

  # 	has_many  :supervisor, :foreign_key => 'contact_id'

  # -------------------------------------------------------

  # 	validates :programyear, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1

  # [:contact_id, :program_id, :profession_id].each do |ids|

  # 	validates_numericality_of :publicfundinglevel, {greater_than_or_equal_to: 0, less_than_or_equal_to: 100}

  def percentual?
    percentvalues == true
  end

  def absolute?
    percentvalues == false
  end

  %i[government agreements privatesector other ppp].each do |fundingsources|
    validates fundingsources, presence: true, numericality: { greater_than_or_equal_to: 0 }
  end

  %i[government agreements privatesector other ppp].each do |fundingsources|
    validates fundingsources, presence: true, numericality: { less_than_or_equal_to: 100 }, if: :percentual?
  end

  def total
    government + agreements + privatesector + other + ppp
  end

  validates :comment, length: { maximum: 200 }

  validate :percent_total_is_consistent, if: :percentual?

  def percent_total_is_consistent
    errors.add(:percentvalues, :inconsistent) if total != 100
  end
end

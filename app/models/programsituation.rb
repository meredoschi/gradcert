class Programsituation < ActiveRecord::Base
  belongs_to :assessment

  # ------- Validations -------------

  validate :duration_consistency

  validates_uniqueness_of :assessment_id

  validates :assessment_id, presence: true

  validates :kind, presence: true, length: { maximum: 3000 }

  validates :goals, presence: true, length:  { maximum: 3000 }

  has_many  :recommendations, dependent: :destroy

  accepts_nested_attributes_for :recommendations, allow_destroy: true

  validates :recommended_duration, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # 	validates :duration_change_requested, :inclusion => { :in => [true] }, if: :duration_changed?, :on => :update

  # 	validates :duration_change_requested, :inclusion => { :in => [false] }, if: :duration_remained?, :on => :update

  # ---------------------------------

  def self.own(user)
    joins(assessment: :contact).merge(Contact.own(user))
  end

  def workload
    recommendations.sum(:theory) + recommendations.sum(:practice)
  end

  def theory
    recommendations.sum(:theory)
  end

  def practice
    recommendations.sum(:practice)
  end

  def current_duration
    assessment.program.duration
  end

  def duration_consistency
    if recommendations.reject(&:marked_for_destruction?).count != recommended_duration
      errors.add(:recommended_duration, :inconsistent)
    end
  end

  def assessmentshortname
    assessment_short_name
  end

  def assessment_short_name
    # 			self.program_short_name

    [program_short_name, institution_short_name].join(' - ')
  end

  def assessment_name
    [program_name, institution_name, profession_name].join(' | ')

    #  			self.assessment.name
  end

  def name
    assessment.name
  end

  def institution_name
    assessment.institution_name
  end

  def institution_short_name
    assessment.institution_short_name
  end

  def contact_name
    assessment.contact_name
  end

  def contact_short_name
    assessment.contact_short_name
  end

  def profession_name
    assessment.profession_name
  end

  def profession_short_name
    assessment.profession_short_name
  end

  def program_name
    assessment.program.programname.name
  end

  def program_short_name
    assessment.program.programname.name
  end

  def duration_remained?
    !duration_changed?
  end

  def self.favorable
    where(favorable: true)
  end

  def duration_changed?
    if current_duration.present? && recommended_duration.present? && current_duration != recommended_duration

      true

    else

      false

     end
  end

  private

  # http://stackoverflow.com/questions/11529143/rails-3-validate-presence-based-off-boolean
  def duration_change_requested?
    duration_change_requested == true
  end
end

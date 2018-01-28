class Diploma < ActiveRecord::Base
  belongs_to :supervisor

  belongs_to :student

  belongs_to :schoolname

  belongs_to :coursename

  belongs_to :degreetype

  belongs_to :profession

  belongs_to :institution

  belongs_to :council

  belongs_to :school

  COUNCILSTATUS = %w[Definitiva Provisória Protocolo].freeze

  scope :for_supervisor, lambda { |supervisor|
                           where(supervisor_id: supervisor.id)
                         }

  # [:profession_id, :degreetype_id, :awarded].each do |n|

  %i[degreetype_id awarded].each do |n|
    validates n, presence: true
  end

  validates :othercourse, length: { maximum: 100 }

  validates :school_id, presence: true, if: proc { |c| c.externalinstitution.blank? }

  #    validate :coursename_presence, if: Proc.new {  |d| d.othercourse.blank? }

  validate :coursename_presence

  def coursename_presence
    errors.add(:coursename_id, :must_be_informed) if coursename.blank?
  end

  #     def council_membership_info_provided?
  #
  #         return councilcredential.present? || councilcredentialstatus.present? || councilcredentialexpiration.present?
  #
  #     end
  #
  #     validate :council_id_required_if_details_provided
  #
  #     def council_id_required_if_details_provided
  #      #  if council_membership_info_provided?
  #         errors.add(:council_id, :required_if_details_provided)
  #     #   end
  #     end
  #
  # validates :school_id, presence: true

  #     validates :institution_id, presence: true, if: Proc.new {|c| c.externalinstitution.blank?}

  validates :externalinstitution, presence: true, length: { maximum: 200 }, if: proc { |c| c.school_id.blank? }

  validates :councilcredentialstatus, absence: true, unless: :council_name_and_credential?

  validates :councilcredentialexpiration, absence: true, unless: :council_name_and_credential?

  #  validates :otherinstitution, presence: true, length:  { maximum: 200 }, if: Proc.new {|c| c.institution.blank?}

  # If institution was selected from the list, values may not be entered manually as well
  # validate :institution_may_not_be_informed_both_ways

  # validate :institution_name_must_be_informed_somehow

  validate :council_name_must_have_credential

  # Used in --> rake fixes:register_makeups
  def self.exists_for_student(s)
    where(student_id: s.id).exists?
  end

  def council_name_must_have_credential
    if council_id.present? && councilcredential.blank?
      errors.add(:councilcredential, :must_be_informed)
    end
  end

  validate :credential_must_belong_to_a_council

  def credential_must_belong_to_a_council
    if councilcredential.present? && council_id.blank?
      errors.add(:council_id, :must_be_informed)
    end
  end

  def institution_name_must_be_informed_somehow
    if school_id.nil? && externalinstitution.blank?
      errors.add(:school_id, :must_be_informed_somehow)
    end
  end

  def institution_may_not_be_informed_both_ways
    if school_id.present? && externalinstitution.present?
      errors.add(:externalinstitution, :need_not_be_specified_manually)
    end
  end

  def council_information_complete?
    (councilcredential.present? && council_id.present? && councilcredentialexpiration.present? && !councilcredentialstatus.blank?)
  end

  def council_name_and_credential?
    (councilcredential.present? && council_id.present?)
  end

  def council_information_all_blank?
    (councilcredential.blank? && council_id.blank? && councilcredentialexpiration.blank? && councilcredentialstatus.blank?)
  end

  # http://stackoverflow.com/questions/5200213/rails-3-f-select-options-for-select
  # 	def options_for_seasons
  # 	['Spring', 'Summer', 'Autumn', 'Winter']
  # 	end
end

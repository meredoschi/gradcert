# frozen_string_literal: true

# Provides logic for programs
class Program < ActiveRecord::Base
  MAX_YEARS = Settings.longest_program_duration.all
  MAX_COMMENT_LEN = Settings.maximum_comment_length.program
  ABBREVIATION_LENGTH = Settings.shortname_len.program
  INSTITUTION_ABBREVIATION_LENGTH = Settings.shortname_len.institution

  has_paper_trail

  # ------------------- Associations ----------------------------------------------------------

  has_many :schoolyears, dependent: :destroy

  accepts_nested_attributes_for :schoolyears, allow_destroy: true

  belongs_to :programname

  belongs_to :schoolterm

  belongs_to :institution

  #
  #   # ------------------- Scopes ----------------------------------------------------------------

  #    http://api.rubyonrails.org/classes/ActiveRecord/Scoping/Named/ClassMethods.html
  scope :pap, -> { where(pap: true) }

  scope :medres, -> { where(medres: true) }
  scope :medicalresidency, -> { where(medres: true) }

  scope :gradcert, -> { where(gradcert: true) }

  scope :with_institution, -> { joins(:institution).uniq.order(:name) }

  #
  #   has_many :courses
  #
  has_many :assignments, dependent: :restrict_with_exception
  has_many :supervisors, through: :assignments
  has_many :assesment, foreign_key: 'program_id',
                       dependent: :restrict_with_exception, inverse_of: :program
  #
  #   # ------------------- Nested models ----------------------------------------------------------
  #
  has_one :admission, dependent: :destroy
  accepts_nested_attributes_for :admission
  has_one :accreditation, dependent: :destroy
  accepts_nested_attributes_for :accreditation
  accepts_nested_attributes_for :accreditation, reject_if: :method___?, allow_destroy: true
  has_one :address, dependent: :destroy
  accepts_nested_attributes_for :address, reject_if: :internal_address?, allow_destroy: true

  #    scope :original, -> { where(original: true) }.includes(:schoolyears)
  #
  #   # ------------------- Validations ------------------------------------------------------------
  #
  validates :comment, length: { maximum: MAX_COMMENT_LEN }
  %i[duration institution_id programname_id schoolterm_id].each do |required_field|
    validates required_field, presence: true
  end
  validates :duration, numericality: { only_integer: true, greater_than_or_equal_to: 1,
                                       less_than_or_equal_to: MAX_YEARS }
  validates :programname_id, uniqueness: { scope: %i[institution_id schoolterm_id] }

  # Open for registrations (within the registration season)
  def self.open
    joins(:schoolterm).merge(Schoolterm.open).unscoped.order(:id)
  end

  def self.from_users_institution(user)
    where(institution_id: user.institution_id)
  end

  #
  #     # ------------------- PENDING Tests  ---------------------------------------------------
  #
  #     # You may need to disable this validation temporarily in order to seed the programs.
  #     validate :duration_consistency unless Settings.data_seed_imminent.programs
  #
  #     validate :schoolyear_range unless Settings.data_seed_imminent.programs
  #
  #     def schoolyear_range
  #       if schoolyears.reject(&:marked_for_destruction?).count > MAX_YEARS
  #         errors.add :base, :unable_to_add_schoolyears_over_max
  #       end
  #     end
  #
  #     def duration_consistency
  #       if schoolyears.reject(&:marked_for_destruction?).count != duration
  #         errors.add(:duration, :inconsistent)
  #       end
  #     end
  #
  #     # -----------------------------------------------------------------------------------------
  #     # TDD - May & June - 2017
  #     # Essentially the same as program_name
  #
  #     =begin
  #
  #     def details_mkdown
  #     sep = Settings.separator_mkdown
  #     prog_details = id.to_s + sep + programname_id.to_s + sep
  #     prog_details += name + sep + institution.id.to_s + sep
  #  prog_details += institution.abbrv + sep + schoolterm.id.to_s + sep + I18n.l(schoolterm.start)
  #
  #     prog_details
  #   end
  #
  #   def info
  #   txt = ''
  #
  #   parent_id_i18n = I18n.t('activerecord.attributes.program.virtual.parentid')
  #   program_i18n = I18n.t('activerecord.models.program').capitalize
  #   name_i18n = I18n.t('name').capitalize
  #   schoolterm_i18n = I18n.t('activerecord.models.schoolterm').capitalize
  #
  #   txt += parent_id_i18n + parentid.to_s + ' ' if parentid.present?
  #
  #   if admission.present? && accreditation.present?
  #
  #   txt = program_i18n + ' <' + id.to_s + '> ' + program_name
  #   txt += ' [' + name_i18n + ' ' + programname.id.to_s + '] '
  #   txt += ', ' + I18n.t('activerecord.models.admission').capitalize + ' ['
  #   txt += admission.id.to_s + '] ' + ', '
  #   txt += I18n.t('activerecord.models.accreditation').capitalize + ' ['
  #   txt += accreditation.id.to_s + ']'
  #
  # else
  #
  # txt += ' [' + id.to_s + ']' + program_name
  #
  # end
  #
  # txt += ', ' + schoolterm_i18n + ' ' + schoolterm.start.year.to_s + ' ['
  # txt += schoolterm.id.to_s + ']'
  #
  # txt
  # end
  #

  def area
    program_area = case # rubocop:disable EmptyCaseCondition
                   when pap? then I18n.t('activerecord.attributes.program.pap')
                   when medres? then I18n.t('activerecord.attributes.program.medres')
                   when gradcert? then I18n.t('activerecord.attributes.program.gradcert')
                   else
                     I18n.t('undefined_value')
                   end

    program_area
  end

  # Alias
  def sector
    area
  end

  delegate :name, to: :programname

  # def registrations
  # Registration.on_program(self)
  # end
  #
  # def revocations
  # registrations.revoked
  # end
  #
  # def cancellations
  # revocations
  # end
  #
  # def seasonwithdraws
  # cancellations.where('registrations.created_at < ?', schoolterm.seasonclosure)
  # end
  #
  # Returns a number
  # def numseasonwithdraws
  # seasonwithdraws.count
  # end
  #
  # Returns a number
  # def numregistrations
  # registrations.count
  # end
  #
  # def with_registered_students?
  # numregistrations.positive? # boolean
  # end
  #
  # def without_registered_students?
  # !with_registered_students?
  # end
  #
  # def external_address?
  # internal == false
  # end
  #
  # def internal_address?
  # !external_address?
  # end
  #
  # def is_active?
  # accreditation.original_or_was_renewed?
  # end
  #
  # def program_name_schoolterm
  # name + ' (' + schoolterm.name + ')'
  # end
  #

  def numschoolyears
    schoolyears.count
  end

  def program_name
    programname.name
  end

  def shortname
    programname.short
  end

  # Alias, for convenience
  def short
    shortname
  end

  def theory
    schoolyears.sum(:theory)
  end

  def practice
    schoolyears.sum(:practice)
  end

  def workload
    theory + practice
  end

  # Related to the institutions association (review in progress)

  def institution_program_name
    name + ' (' + institution.name + ')'
  end

  def program_institution_short_name
    shortname + ' (' + institution.shortname + ')'
  end

  # Alias
  def program_name_with_institution
    institution_program_name
  end

  # Abbreviated institution name.  Used in registrations helper for admins and managers (schoolyear)
  def name_term_institution_short
    [short, schoolterm.name, institution.abbrv].join(' | ')
  end

  #
  # TDD finish

  # This is breaking because the original data is not unique...
  #   validates_uniqueness_of :previouscode, :scope => [:schoolterm_id]

  # Clone
  #   validates_uniqueness_of :programname_id, :scope => [:institution_id, :schoolterm_id]

  # http://apidock.com/rails/ActiveRecord/SpawnMethods/merge
  #  scope :with_available_books, joins(:books).merge(Book.available)

  #  scope :active, joins(:accreditation).merge(Accreditation.all)

  #   validates :externalvenuename, length:  { maximum: 120 }

  #   def self.active

  #       joins(:accreditation).where({ "accreditations.original" => true }  })

  #   end

  # ----------------- Model finders ---------------------

  # 2018 - Spec

  #  def maxenrollment
  #    admission.grantsgiven
  #  end

  # Tested code end

  # ----
  #  def self.from_institution(i)
  #    where(institution_id: i.id)
  #  end

  #  def self.find_active_programnames
  #    Programname.active.order(:name)
  #  end

  #  def self.find_active_pap_programnames
  #    Programname.active.order(:name).pap
  #  end

  #  def self.find_active_medres_programnames
  #    Programname.active.order(:name).medres
  #  end

  #
  # -----------------------------------------------------

  # # This method will be refactored.  To do: use contextual instead
  # def self.recent
  # joins(:schoolterm).merge(Schoolterm.active)
  # end
  #
  # Past years
  # def self.finished
  # where.not(id: recent)
  # end
  #
  # Processed by the system
  # def self.modern
  # joins(:schoolterm).merge(Schoolterm.modern)
  # end
  #
  # Last year processed by the (other) legacy system - Pick
  # def self.legacy
  # where.not(id: modern)
  # end
  #

  def self.for_schoolterm(schoolterm)
    where(schoolterm_id: schoolterm.id)
  end

  #
  # def self.active
  # Program.not_revoked.not_suspended
  # end
  #
  # def self.ordered_by_name_and_institution
  # joins(:programname).joins(:institution).order('programnames.name, institutions.name')
  # end
  #
  # def self.ordered_by_institution_and_name
  # joins(:programname).joins(:institution).order('institutions.name, programnames.name')
  # end
  #
  # def self.inactive
  # Program.not_original.not_renewed
  # end
  #
  # def self.original
  # Program.joins(:accreditation).merge(Accreditation.original)
  # end
  #
  # def self.renewed
  # Program.joins(:accreditation).merge(Accreditation.renewed)
  # end
  #
  # def self.suspended
  # Program.joins(:accreditation).merge(Accreditation.suspended)
  # end
  #
  # def self.revoked
  # Program.joins(:accreditation).merge(Accreditation.revoked)
  # end
  #
  # def self.not_original
  # Program.joins(:accreditation).merge(Accreditation.not_original)
  # end
  #
  # def self.not_renewed
  # Program.joins(:accreditation).merge(Accreditation.not_renewed)
  # end
  #
  # def self.not_suspended
  # Program.joins(:accreditation).merge(Accreditation.not_suspended)
  # end
  #
  # def self.not_revoked
  # Program.joins(:accreditation).merge(Accreditation.not_revoked)
  # end
  #
  # def active_registrations
  # schoolyears.joins(:registration).merge(Registration.active)
  # end
  #
  # def num_active_registrations
  # active_registrations.count
  # end
  #
  # def inactive_registrations
  # schoolyears.joins(:registration).merge(Registration.inactive)
  # end
  #
  # def num_inactive_registrations
  # active_registrations.count
  # end
  #

  def schoolyear_quantity
    schoolyears.reject(&:marked_for_destruction?).count
  end

  # -------------------------------------------------------------------------------------------

  # def self.default_scope
  # Program.joins(:programname).order('programnames.name')
  # end
  #
  # def self.with_assessment
  # self.find_by_sql "select * from programs p, assessments a where a.program_id=p.id"
  # rewrote as -->
  # Assessment.includes(:program)
  # end
  #
  # def self.from_own_institution(user)
  # joins(:institution).where('programs.institution_id= ?', user.institution.id)
  # end
end

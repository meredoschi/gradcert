# Registration functionality and associated data logic
class Registration < ActiveRecord::Base
  # ------------------- References ------------------------

  SEPARATOR = Settings.separator # CSV

  EXCLUDED_COLUMNS_FROM_CSV = %w[registrationkind_id returned finalgrade medres pap
                                 supportingdocumentation completion_id created_at updated_at].freeze

  has_many  :feedback

  has_many  :annotation, dependent: :restrict_with_exception

  has_many  :event, dependent: :restrict_with_exception

  has_one :accreditation
  accepts_nested_attributes_for :accreditation

  has_one :registrationkind
  accepts_nested_attributes_for :registrationkind

  belongs_to :student
  belongs_to :schoolyear

  # Added in 2017 - To be fully implemented (under development)
  has_one :completion
  accepts_nested_attributes_for :completion

  has_one :makeupschedule
  accepts_nested_attributes_for :makeupschedule

  # --- References end

  has_paper_trail # Auditing

  mount_uploader :supportingdocumentation, SupportingdocumentationUploader # Carrierwave uploads

  validates :supportingdocumentation, file_size: { less_than_or_equal_to: 2.megabytes }

  belongs_to :statement

  # New - 2017 registration
  validates :student_id, presence: true

  validates :schoolyear_id, presence: true

  # *********

  # 	validates_uniqueness_of :student_id

  validates :student_id, presence: true
  validates_uniqueness_of :schoolyear_id, scope: [:student_id]

  scope :suspended, -> { where(suspended: true) }

  scope :withdrawn, -> { where(withdrawn: true) }

  scope :not_suspended, -> { where(suspended: false) }

  scope :not_withdrawn, -> { where(withdrawn: false) }

  #    scope :returned, -> { where(returned: true) }

  scope :processed, -> { where(returned: false) }

  #   scope :not_returned, -> { where(returned: false) }

  # Alias
  scope :not_confirmed, -> { where(returned: false) }

  scope :single_year_program, -> { joins(schoolyear: :program).where('programs.duration=1') }

  scope :two_year_program, -> { joins(schoolyear: :program).where('programs.duration=2') }

  # 	validates :comment, length:  { maximum: 150 }

  #  validates :comment, presence: true, if: :inactive?

  # validate :schoolyear_enrollment_limit

  # To do -->
  # Properly implement contextual (rather than active) for programname
  # (i.e. active from start to finish date)

  # Other occurrences ->
  #   app/models//program.rb:237:  def self.find_active_pap_programnames
  #   app/models//registration.rb:320:  def self.find_active_pap_programnames
  #   app/helpers//programs_helper.rb:128:
  #   when is_pap_manager(user) then Program.find_active_pap_programnames

  # New for 2018

  def self.with_statements_in_calendar_year(yr)
    where(id: Statement.registration_ids_for_payments_performed_on_calendar_year(yr))
  end

  def self.student_ids
    pluck(:student_id).sort.uniq
  end

  def self.find_active_pap_programnames
    # Fix this !
    #
    Programname.all
    #
    # 			Programname.active.order(:name).pap
  end

  #
  def self.find_active_medres_programnames
    Programname.active.order(:name).medres
  end

  #  *** To do above ****

  # -----------------------------------------------------

  # Alias
  def sector
    user_area
  end

  # checking by user
  # to do: also check by schoolyear.program

  def student_permission
    student.contact.user.permission
  end

  def user_area
    if student_permission.pap?
      'pap'
    elsif student_permission.medres?
      'medres'
    else
      ''
    end
  end

  def required_minimum_for_sector
    student_permission = student.contact.user.permission

    @num_days = Settings.min_number_days_worked.pap if student_permission.pap?

    if student_permission.medres?
      @num_days = Settings.min_number_days_worked.medres
    end

    @num_days
  end

  # For active schoolterms
  def self.activeterms
    joins(:accreditation).where('accreditations.start >=? AND accreditations.start <=?',
                                Schoolterm.earliest_start_contextual_today,
                                Schoolterm.latest_finish_contextual_today)
  end

  def early_cancellation?
    revoked? && num_days_worked_before_cancelling <
      required_minimum_for_sector #  Actual days worked
  end

  # Another alias
  def self.on_schoolterm(s)
    for_schoolterm(s)
  end

  # New, first year
  def rookie?
    (school_term == Schoolterm.latest && schoolyear.programyear == 1 && regular?)
  end

  # Quick production fix.
  def upcoming?
    school_term == Schoolterm.latest
  end

  # Better way to name, i.e. from schoolterms which "are relevant" today.
  def self.in_evidence_today
    joins(schoolyear: [program: :schoolterm]).merge(Schoolterm.active_today)
  end

  # 2017 - Previous registration - makes sense only for special ones
  def previous
    previous_registration_id = registrationkind.previousregistrationid

    Registration.where(id: previous_registration_id).first
  end

  def self.ids_contextual_on(dt)
    @all_schoolterms = Schoolterm.all
    @all_registrations = Registration.all
    @registration_ids_in_context = []

    relevant_terms = @all_schoolterms.contextual_on(dt)

    relevant_terms.each_with_index do |s, i|
      term_registrations = @all_registrations.on_schoolterm(s)
      registration_ids_in_term_context = term_registrations.merge(Schoolyear.level((1 + i)))
      @registration_ids_in_context << registration_ids_in_term_context
    end

    @registration_ids_in_context.flatten
  end

  def self.contextual_on(dt)
    where(id: ids_contextual_on(dt))
  end

  # Contextual ids on the date provided until today
  def self.ids_contextual_from(dt)
    registrations = all
    registrations_contextual_today = registrations.contextual_today
    ids_contextual_today = registrations_contextual_today.pluck(:id)
    registrations_contextual_previously = registrations.contextual_on(dt)
    ids_contextual_previously = registrations_contextual_previously.pluck(:id)
    (ids_contextual_previously + ids_contextual_today).uniq
  end

  # Returns actual registration ids
  def self.contextual_from(dt)
    where(id: ids_contextual_from(dt))
  end

  # Convenience method
  def self.contextual_today
    contextual_on(Date.today)
  end

  def schoolyear_enrollment_limit
    places_authorized = schoolyear.places_available.first.authorized
    return unless schoolyear.enrollment >= places_authorized
    errors.add(:_, 'Todas as vagas autorizadas já foram preenchidas')
  end

  def mothers_name_is_present
    return unless personalinfo.mothers_name_is_present
    errors.add(:personalinfo, :mothersname_must_be_present)
  end

  def self.freshmen
    joins(:student).joins(schoolyear: :program).where('schoolyears.programyear = 1')
  end

  # Generic version
  def self.veterans
    freshmen_ids = freshmen.pluck(:id).uniq
    where.not(id: freshmen_ids)
  end

  def self.sophmores
    joins(:student).joins(schoolyear: :program).where('schoolyears.programyear = 2')
  end

  def self.not_veteran_student_ids
    not_veterans.pluck(:student_id).sort
  end

  # Alias (for convenience)
  def self.not_veterans
    freshmen
  end

  # Belongs to a schoolyear, which is part of a program whose schoolterm is open for registrations
  def open?
    schoolyear.program.schoolterm.open? if schoolyear.present?
  end

  # **************************** Accreditation *******************************
  def self.program_years_offered
    joins(:schoolyear).pluck(:programyear).sort.uniq
  end

  def self.on_program_year(py)
    joins(:schoolyear).where('schoolyears.programyear = ? ', py)
  end

  # Does not get paid!
  def self.pap_early_cancellations
    pap.cancelled.where('accreditations.revocation-accreditations.start< ?',
                        Settings.min_number_days_worked.pap)
  end

  def self.pap_early_cancellation?(r)
    pap_early_cancellations.exists?(id: r.id)
  end

  def num_days_worked_before_cancelling
    (accreditation.revocation - accreditation.start).to_i if revoked?
  end

  # Which belong to a specific schoolterm
  def self.for_schoolterm(s)
    joins(schoolyear: [program: :schoolterm]).where('schoolterms.id = ?', s.id)
  end

  def self.find_active_programnames
    Programname.active.order(:name)
  end

  def self.active
    Registration.not_revoked.not_suspended
  end

  def self.inactive
    Registration.not_original.not_renewed
  end

  def self.original
    Registration.joins(:accreditation).merge(Accreditation.original)
  end

  def self.renewed
    Registration.joins(:accreditation).merge(Accreditation.renewed)
  end

  def self.suspended
    Registration.joins(:accreditation).merge(Accreditation.suspended)
  end

  def self.revoked
    Registration.joins(:accreditation).merge(Accreditation.revoked)
  end

  # Alis - for convenience
  def self.cancelled
    revoked
  end

  def self.not_original
    Registration.joins(:accreditation).merge(Accreditation.not_original)
  end

  #
  def self.not_renewed
    Registration.joins(:accreditation).merge(Accreditation.not_renewed)
  end

  #
  def self.not_suspended
    Registration.joins(:accreditation).merge(Accreditation.not_suspended)
  end

  #
  def self.not_revoked
    Registration.joins(:accreditation).merge(Accreditation.not_revoked)
  end
  #

  # Completion

  # Scheduled to be made up (e.g. next year)
  #  Set in completion, *before* new registration (registration kind = makeup) is created
  def self.mustmakeup
    joins(:completion).merge(Completion.mustmakeup)
  end

  # Regular registration (i.e. neither repeat nor makeup)
  def self.regular
    joins(:registrationkind).merge(Registrationkind.regular)
  end

  # Alias
  def self.normal
    regular
  end

  def self.special
    joins(:registrationkind).merge(Registrationkind.special)
  end

  def self.not_related_to_a_previous_one
    regular # by simple logic (booleans) # Alias, for convenience
  end

  def self.related_to_a_previous_one
    where.not(id: not_related_to_a_previous_one)
  end

  # Make up registration (for a previous one)
  def self.makeup
    joins(:registrationkind).merge(Registrationkind.makeup)
  end

  # Repeated course (fail grade on the previous registration)
  def self.repeat
    joins(:registrationkind).merge(Registrationkind.repeat)
  end

  def makeup?
    registrationkind.makeup?
  end

  def repeat?
    registrationkind.repeat?
  end

  def special?
    if registrationkind

      registrationkind.repeat? || registrationkind.makeup?

    else
      false
    end
  end

  def regular?
    if registrationkind # tests for nil

      registrationkind.regular

    else

      true

    end
  end

  # Alias
  def normal?
    regular?
  end

  def related_to_a_previous_one?
    registrationkind.related_to_a_previous_registration?
  end

  def not_related_to_a_previous_one?
    registrationkind.not_related_to_a_previous_registration?
  end

  def active?
    accreditation.original_or_was_renewed?
  end

  # Useful for special payroll
  def inactive?
    !active?
  end

  def original?
    accreditation.original?
  end

  def renewed?
    accreditation.renewed?
  end

  def suspended?
    accreditation.was_suspended?
  end

  def returned?
    returned
  end

  def cancelled?
    accreditation.was_revoked?
  end

  def revoked?
    cancelled?
  end

  def vacationed?
    Event.vacations_for_registration(self).exists?
  end

  def annotated?
    annotation.present?
  end

  # Alias
  def self.current
    activeterms
  end

  # --- As of Payroll

  # For active schoolterms
  def self.candidates_for_payroll(p)
    activeterms.where('accreditations.start <=?', p.finish)
  end

  # Regular (i.e. active) matriculations during that payroll period.
  # To do: rework this more clearly (in accreditation.rb)
  def self.regular_for_payroll(p)
    candidates_for_payroll(p)
      .ordered_by_contact_name.where.not(id: Registration.cancelled_before_payroll(p))
      .where.not(id: Registration.suspended_before_payroll(p))
  end

  # Convenience method
  def self.regular_within_payroll_context(p)
    regular_for_payroll(p).contextual_on(p.monthworked)
  end

  # Late registrations (during the specified payroll).
  def self.late_during_payroll(p)
    joins(:accreditation)
      .where('accreditations.start >? AND accreditations.start <=?', p.start, p.finish)
      .ordered_by_contact_name
  end

  def self.cancelled_during_payroll(p)
    joins(:accreditation)
      .where('accreditations.revocation >=? AND accreditations.revocation <=?', p.start, p.finish)
      .ordered_by_contact_name
  end

  # Useful for total absences calculations
  def self.not_cancelled_during_payroll(p)
    where.not(id: cancelled_during_payroll(p))
  end

  def self.cancelled_before_payroll(p)
    revoked.joins(:accreditation)
           .where('accreditations.revocation <?', p.start)
           .ordered_by_contact_name
  end

  def self.suspended_before_payroll(p)
    suspended.joins(:accreditation)
             .where('accreditations.suspension <?', p.start)
             .ordered_by_contact_name
  end

  def self.renewed_before_payroll(p)
    renewed.joins(:accreditation)
           .where('accreditations.renewal <?', p.start)
           .ordered_by_contact_name
  end

  def self.suspended_during_payroll(p)
    joins(:accreditation)
      .where('accreditations.suspension >=? AND accreditations.suspension <=?', p.start, p.finish)
      .ordered_by_contact_name
  end

  def self.renewed_during_payroll(p)
    joins(:accreditation)
      .where('accreditations.renewal >=? AND accreditations.renewal <=?', p.start, p.finish)
      .ordered_by_contact_name
  end

  def self.created_since_payroll(p)
    joins(:accreditation)
      .where('accreditations.start >=?', p.start)
      .ordered_by_contact_name
  end

  def self.for_student(s)
    joins(:student).where(student_id: s.id)
  end

  def self.from_institution(i)
    joins(student: :contact).merge(Contact.from_institution(i))
  end

  def self.on_schoolyear(s)
    joins(schoolyear: :program).where('schoolyears.id = ? ', s.id)
  end

  def self.on_program(p)
    joins(schoolyear: :program).where('programs.id = ? ', p.id)
  end

  def self.ordered_by_contact_name
    joins(student: :contact).order('contacts.name')
  end

  # SSN = Social Security Number (NIT)
  def self.ordered_by_ssn
    joins(student: { contact: :personalinfo })
      .order('personalinfos.socialsecuritynumber')
  end

  def self.cancelled_on_this_payroll(p)
    joins(:accreditation)
      .merge(Accreditation.cancelled_on_this_payroll(p))
  end

  def cancelled_on_this_payroll?(p)
    accreditation.cancelled_on_this_payroll?(p)
  end

  def self.suspended_on_this_payroll(p)
    joins(:accreditation)
      .merge(Accreditation.suspended_on_this_payroll(p))
  end

  def suspended_on_this_payroll?(p)
    accreditation.suspended_on_this_payroll?(p)
  end

  def self.renewed_on_this_payroll(p)
    joins(:accreditation)
      .merge(Accreditation.renewed_on_this_payroll(p))
  end

  # Returned from maternity leave, for instance

  def renewed_on_this_payroll?(p)
    accreditation.renewed_on_this_payroll?(p)
  end

  def self.annotated_students_for_payroll(p)
    annotations_for_payroll(p).joins(:student)
  end

  def self.skipped_students_for_payroll(p)
    joins(annotation: :payroll)
      .merge(Annotation.skipped)
      .where('annotations.payroll_id= ?', p).joins(:student)
  end

  def self.annotated_ids
    joins(:annotation).pluck(:id).sort.uniq
  end

  def self.confirmed_students_for_payroll(p)
    where.not(id: skipped_students_for_payroll(p))
  end

  # i.e. annotations for a particular registration
  # Alias...

  # Get unique

  def self.ids_with_events
    joins(:event).uniq.sort
  end

  def self.ids_with_annotations
    joins(:annotation).uniq.sort
  end

  def self.with_events
    Registration.ordered_by_contact_name.joins(:event)
  end

  # Number of annotations

  def numannotations
    annotations.count
  end

  def annotations
    #			annotation
    annotation.includes(:payroll)
  end

  def self.all_annotations_for_payroll(p)
    # includes skipped
    joins(annotation: :payroll)
      .where('annotations.payroll_id= ?', p)
  end

  def self.annotations_for_payroll(p)
    joins(annotation: :payroll)
      .where('annotations.payroll_id= ?', p)
      .merge(Annotation.not_skipped) # i.e. annotated and not skipped
  end

  def self.annotated
    joins(:annotation).uniq.sort
  end

  def self.not_annotated
    # http://stackoverflow.com/questions/25086952/rails-how-do-i-exclude-records-with-entries-in-a-join-table
    where.not(id: annotated)
  end

  def self.ordered_by_name_and_institution
    joins(student: { contact: { user: :institution } })
      .order('contacts.name, institutions.name')
  end

  # Default scope was used when the system was first developed (contact name ascending)
  def self.reordered_by_programyear_and_contact_name
    joins(schoolyear: [program: :institution])
      .joins(student: :contact)
      .reorder('schoolyears.programyear, contacts.name')
  end

  # Alias
  def self.ordered_by_programyear_and_contact_name
    reordered_by_programyear_and_contact_name
  end

  def self.institutions
    joins(student: { contact: { user: :institution } })
  end

  def self.institution_ids
    joins(student: { contact: { user: :institution } })
      .pluck('institutions.id').uniq.sort
  end

  def self.ordered_by_institution_and_name
    joins(student: { contact: { user: :institution } })
      .order('institutions.name, contacts.name')

    # 	Registration.joins(student: :contact).order('contacts.name')
  end

  def self.annotated_ordered_by_contact_name
    Registration.joins(student: :contact).joins(:annotation)
                .order('contacts.name')
  end

  def self.from_own_institution(user)
    joins(schoolyear: :program)
      .merge(Program.from_own_institution(user))
  end

  def self.pap
    joins(schoolyear: :program)
      .merge(Program.pap)
  end

  def status
    if active?

      active_details

    else

      inactive_details

    end
  end

  def namecpfinstitutionstatus
    if active?

      namecpfinstitution

    else

      inactive_reminder + namecpfinstitution

    end
  end

  # Used on the legal form (contract the student has to sign)
  def program_name_and_schoolyear
    programyear.to_s + 'º ' + program_name
  end

  def program_name_and_schoolyear_start
    term_start = schoolyear.program.schoolterm.start.year.to_s
    program_name_and_schoolyear + ' ' + I18n.t('start') + ' ' + term_start
  end

  def program_short_name_and_schoolyear
    programyear.to_s + 'º ' + program_name_short
  end

  def program_short_name_and_schoolyear_start
    term_start = schoolyear.program.schoolterm.start.year.to_s
    program_short_name_and_schoolyear + ' ' + I18n.t('start') + ' ' + term_start
  end

  # Used on student registration confirmation receipt
  def institution_municipality_name
    student.contact.user.institution.address.municipality.name
  end

  def report_details
    namecpf + ' - ' + program_name_and_schoolyear_start
  end

  def student_name_id_schoolyear_term
    student_name_id_i18n + program_short_name_and_schoolyear_start
  end

  def student_name_id_i18n
    student_name + ' (' + student_id_i18n + ' ' + student.id.to_s + ') '
  end

  # Integer
  def term_start_year
    schoolyear.term_start_year
  end

  def year_entered_i18n
    schoolyear.year_entered_i18n
  end

  def program_short_name_year_entered
    program_short_name_and_schoolyear + ' - ' + year_entered_i18n
  end

  # With student id
  def student_name_id_with_label_schoolyear_term
    student_name_id_i18n + ' - ' + program_short_name_year_entered
  end

  # Convenience method, updated version of details.
  def detailed
    name_ids_schoolyear_institution_abbrv + ' (' + institution + ')'
  end

  def student_id_i18n
    I18n.t('activerecord.attributes.registration.student_id').capitalize
  end

  def model_name_i18n
    I18n.t('activerecord.models.registration').capitalize
  end

  # Registration and Student models
  def model_names_and_ids
    model_name_i18n + ' ' + id.to_s + ', ' + student_id_i18n + ' ' + student.id.to_s
  end

  def name_model_labels_i18n
    student_name + ' (' + model_names_and_ids + ')'
  end

  # With *both* registration and student ids
  def name_ids_schoolyear_institution_abbrv
    name_model_labels_i18n + ' - ' + program_short_name_and_schoolyear
  end

  def student_name_schoolyear_institution_abbrvs
    name_model_labels_i18n + ' - ' + program_short_name_year_entered
  end

  # CSV Format

  def ordinal
    Pretty.ordinal_suffix
  end

  # Alias - Useful for Brazil
  def cpf
    tin
  end

  def schoolyear_ordinal
    schoolyear.ordinalyr
  end

  def report_details_csv
    [name, tin, schoolyear_ordinal, program_name,
     I18n.t('start'), program_short_name_year_entered].join(SEPARATOR)
  end

  # with institution name
  def full_details
    student.contact.name + ' [' + programyear.to_s + ' ' + program_name + ']' + ' ' + institution
  end

  def details
    student.contact.name + ' [' + programyear.to_s + ' ' + program_name + ']'
  end

  def ssn
    student.contact.personalinfo.socialsecuritynumber
  end

  def nit
    ssn
  end

  # Situation confirmed
  def self.confirmed
    joins(:accreditation).merge(Accreditation.registration_situation_confirmed)
  end

  # Situation pending
  def self.pending
    joins(:accreditation).merge(Accreditation.registration_situation_pending)
  end

  def ordinal_year_i18n
    schoolyear.ordinal_year_i18n
  end

  def incoming_cohort_i18n
    schoolyear.incoming_cohort_i18n
  end

  def student_name_cohort
    student_name + ' (' + ordinal_year_i18n + ' - ' + incoming_cohort_i18n + ')'
  end

  def cohort
    I18n.t('cohort') + ': ' + I18n.t('start') + ' ' + I18n.l(schoolyear.program.schoolterm.start)
  end

  # taxpayer id - e.g. CPF in Brazil
  def tin
    student.contact.personalinfo.tin
  end

  def annotation_for_payroll(p)
    annotation.where(payroll: p)
  end

  def annotated_on_payroll?(p)
    annotation_for_payroll(p).exists?
  end

  def name
    student.contact.name + ' - ' + institution + ' (' + programyear.to_s + 'º ' + program_name + ')'
  end

  def school_term
    schoolyear.school_term
  end

  # Alias
  def self.from_schoolterm(s)
    for_schoolterm(s)
  end

  # 2017 - Registration season
  def self.with_diploma_coursename
    joins(student: :diploma).where('diplomas.coursename_id>0')
  end

  def self.without_diploma_coursename
    where.not(id: with_diploma_coursename)
  end
  # -----------------------

  # Schoolterms for a set of registrations
  def self.schoolterms
    joins(schoolyear: [program: :schoolterm]).pluck('schoolterms.id')
  end

  def self.for_programyear(yr)
    prog_year = yr.to_i
    joins(:schoolyear).merge(Schoolyear.level(prog_year))
  end

  # Also aliased on schoolyear.rb, for convenience
  def self.on_programyear(yr)
    for_programyear(yr)
  end

  def school_term_name
    schoolyear.school_term_name
  end

  def cohort_start
    schoolyear.cohort_start
  end

  def schoolyear_and_cohort
    schoolyear_ordinal + program_name + ' [' + cohort_start + ']'
  end

  def schoolyear_with_institution_and_term
    schoolyear_ordinal + ' ' + program_name + ' [' + institution + '] ' + cohort_start
  end

  def institution_and_schoolyear
    institution + ' (' + programyear.to_s + 'º ' + program_name + ')'
  end

  def id_name_tin
    student_name + ' [ID ' + id.to_s + '] ' + ' (' + student.contact.personalinfo.tin + ')'
  end

  def student_name
    student.contact.name
  end

  # Name and brazilian taxpayer id
  def namecpf
    student_name + ' (' + student.contact.personalinfo.tin + ')'
  end

  def institution_abbreviation
    inst = student.contact.user.institution

    inst.abbrv
  end

  # Name and brazilian taxpayer id
  def namecpfinstitution
    namecpf + ' | ' + institution
  end

  def schoolyear_name
    schoolyear.program_name if schoolyear.present?
  end

  def program_name
    programname.name
  end

  # Abbreviated name
  def program_name_short
    programname.short
  end

  # Alias
  def program_short_name
    program_name_short
  end

  def programname
    schoolyear.program.programname
  end

  def programyear
    schoolyear.programyear
  end

  def familycode
    student.profession.professionalfamily.familycode
  end

  def institution
    schoolyear.program.institution.name
  end

  # Returns institution id - Used in total absences report
  def institution_id
    schoolyear.program.institution.id
  end

  def self.medres
    where(medres: true)
  end

  def pap?
    pap
  end

  def medres?
    medres
  end

  # Institutions with at least one active registration
  def self.active_institutions
    Institution.where(id: active_institution_ids)
  end

  # Institutions with at least one active registration
  def self.active_institution_ids
    active.joins(student: { contact: { user: :institution } }).pluck('institutions.id').uniq
  end

  # Newer methods for 2017, see rake task reports:new_registrations

  def suspension_details_i18n
    '*** ' + I18n.t('suspended.f').capitalize + ' ' + I18n.l(accreditation.suspension,
                                                             format: :compact) + ' *** '
  end

  def entered_on_i18n
    I18n.t('entered_on').capitalize + ' ' + I18n.l(accreditation.start, format: :compact)
  end

  def started_on_i18n
    txt = I18n.t('activerecord.attributes.accreditation.start').capitalize
    txt += ' ' + I18n.l(accreditation.start, format: :compact)
    txt
  end

  def cancelled_on_i18n
    txt = I18n.t('activerecord.attributes.accreditation.revocation').capitalize
    txt += ' ' + I18n.l(accreditation.revocation, format: :compact)
    txt
  end

  def renewed_on_i18n
    txt = I18n.t('activerecord.attributes.accreditation.renewal').capitalize
    txt += ' ' + I18n.l(accreditation.suspension, format: :compact)
    txt
  end

  def suspended_on_i18n
    txt = I18n.t('activerecord.attributes.accreditation.suspension').capitalize
    txt += ' ' + I18n.l(accreditation.suspension, format: :compact)
    txt
  end

  # Future to do: include suspension, renewal info when applicable
  def revocation_details_i18n
    entered_on_i18n + ', *** ' + cancelled_on_i18n + ' *** '
  end

  def inactive_details
    suspension_details_i18n if suspended?
    revocation_details_i18n if cancelled?
  end

  # prefix reminders
  def active_details
    @situation = entered_on_i18n

    @situation += ', ' + suspended_on_i18n + ', ' + renewed_on_i18n if renewed?

    @situation
  end

  # http://ruby-doc.org/stdlib-2.2.0/libdoc/csv/rdoc/CSV.html
  def self.to_csv
    #
    CSV.generate(col_sep: SEPARATOR) do |csv|
      text_column_names = column_names - EXCLUDED_COLUMNS_FROM_CSV
      csv << text_column_names + time_column_names
      all.each do |registration|
        row = registration.attributes.values_at(*text_column_names)
        row += registration.attributes.values_at(*time_column_names)
        csv << row
      end
    end
  end

  protected

  # prefix reminders
  # Original method

  def inactive_reminder
    suspension_details_i18n if suspended?

    cancellation_details_i18n if cancelled?
  end
end

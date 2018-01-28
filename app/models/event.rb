# Events are may be "simple" (absences) or leavetypes
class Event < ActiveRecord::Base
  # ------------------- References ------------------------

  # 	belongs_to :user

  # 	has_many  :supervisor, :foreign_key => 'contact_id'

  # -------------------------------------------------------

  has_paper_trail

  # ----- Tested code -----

  belongs_to :annotation

  belongs_to :registration

  belongs_to :leavetype

  # ----------------------

  mount_uploader :supportingdocumentation, SupportingdocumentationUploader # Carrierwave uploads

  scope :payroll_search, ->(payroll) { for_payroll_id(payroll) }

  scope :institution_search, ->(institution) { for_institution_id(institution) }

  scope :schoolterm_search, ->(schoolterm) { for_schoolterm_id(schoolterm) }

  ## *********************************************************
  ## Marcelo - Dec 2017 - Tested validations (RSPEC) start

  %i[registration_id start finish].each do |required_field|
    validates required_field, presence: true
  end

  validate :start_may_not_be_in_anticipation, if: :dates_exist?

  validates :leavetype_id, absence: true, if: :absence?

  validates :leavetype_id, presence: true, unless: :absence?

  #  #
  #   ## Tested validations finish
  #
  #   # Hotfix - to prevent retroactive start
  #   validates_date :start, on: :create, after: Payroll.latest_completed.first.finish
  #
  #   #  validates_date :start, on: :update, after: Payroll.actual.completed.latest.first.finish, if: :fairly_recent?
  #   #
  #
  #   #
  #
  #  ********************** To do: RSPEC validations ******************************************
  #
  #   # uncommented block =begin
  #   #  --- end tests
  #
     validates :leavetype_id, presence: true, unless: -> { absence_or_leavetype_nil? }
  #
     validate :registration_must_be_active, unless: :residual?
  #
     validates :start, :finish, overlap: { scope: 'registration_id' }, if: :dates_exist?
  #

 # Hotfix - disabled 
 #      validate :finish_must_be_prior_to_registration_cancellation_date, if: :actual?
  #
  #    validate :finish_must_be_prior_to_registration_cancellation_date, :if => lambda { self.finished? }
  # ---------------

     validate :start_may_not_be_retroactive
  #
     validate :finish_cannot_be_prior_to_start, if: :dates_exist?
  #
     validate :finish_may_not_be_in_anticipation, unless: :paid_leave?

     validate :finish_may_not_be_in_anticipation, if: -> { dates_exist? && absence? }
  #
     validate :absence_or_leave_must_be_selected
  #
  #   # i.e. processing already started on previous months
  #
     validate :finish_may_not_be_retroactive, if: :archived?
  #
      validate :vacation_must_not_exceed_limit, if: :vacation?
  #
     validate :start_date_presence
     validate :finish_date_presence
  #

  ## **********************************************************

  ## Tested code start

  def start_date_exists?
    Timeliness.parse(start)
  end

  def finish_date_exists?
    Timeliness.parse(finish)
  end

  def absence_or_leavetype_nil?
    absence? || leavetype_nil?
  end

  def fairly_recent?
    threshold = Settings.created_recently.maximum_number_days_ago

    created_at < Time.zone.now - threshold
  end

  ## ------- rspec finish -----------------

  #
  # ---

  # RSPEC --- July 2017

  #  validate :start_may_not_be_retroactive, :if => lambda { self.dates_exist? && self.ongoing? }

    def archived?
      processed
    end

    def ongoing?
      !archived?
    end

  def vacation?
    @result = false

    @result = leavetype.vacation? if leavetype.present? # self here is implicit

    @result
  end

  def retroactive_start?
    @status = false

    @status = true if start <= Payroll.latestfinishdate

    @status
  end

  def vacation_must_not_exceed_limit
    days_already_taken = Event.where.not(id: id).days_vacationed(registration)

    return unless numdays + days_already_taken > Settings.vacation_days_allowed

    errors.add(:finish, :exceeds_the_vacation_days_quota)
  end

  # New for 2017

  def self.started_during_the_previous_term
    previous_term = Schoolterm.latest.previous.first

    Event.where('start >= ? and start <= ?', previous_term.start, previous_term.finish)
  end

  # Latest = current term, essentially
  def self.finish_on_the_latest_term
    latest_term = Schoolterm.latest

    Event.where('finish >= ? and finish <= ?', latest_term.start, latest_term.finish)
  end

  # Convenience method, for clarity.
  # Introduced in 2017.
  def self.previous_term_overflow
    started_during_the_previous_term.finish_on_the_latest_term
  end

  #   has_attached_file :image
  #   validates_attachment_presence :image

  #
  #  :if => lambda { |r| r.bmi_calculation? && r.is_metric? }
  #

  # i.e. Absences = false and no leavetype selected
  def leavetype_nil?
    !absence && leavetype_id.nil?
  end

  def absence_or_leave_must_be_selected
    return unless absence == false && leavetype_id.nil?
    errors.add(:absence, :event_type_must_be_selected)
  end

  # https://github.com/adzap/timeliness
  def start_date_presence
    errors.add(:start, :required) if Timeliness.parse(start).nil?
  end

  def finish_date_presence
    errors.add(:finish, :required) if Timeliness.parse(finish).nil?
  end

  def dates_exist?
    (start_date_exists? && finish_date_exists?)
  end

  def registration_must_be_active
    return unless registration.present? && registration.inactive?
    errors.add(:registration_id, :must_be_active)
  end

  def finish_may_not_be_retroactive
    return unless finish <= Payroll.latestfinishdate
    errors.add(:finish, :may_not_be_retroactive)
  end

  def actual_days_within_maximum_limit
    vacation = Leavetype.vacation.first

    return unless actualdays > vacation.maximumlimit

    errors.add(:finish, :must_be_within_maximum_limit)
  end

  #  http://stackoverflow.com/questions/22473391/custom-search-with-ransacker

  def self.ransackable_scopes(_auth_object = nil)
    %i[payroll_search institution_search schoolterm_search]
  end

  def confirmed?
    confirmed == true
  end

  def start_may_not_be_retroactive
    return unless start.present? && start <= Payroll.latestfinishdate
    # if start<=Bankpayment.latestdone.payroll.paymentdate.beginning_of_month
    errors.add(:start, :may_not_be_retroactive)
  end

  def start_may_not_be_in_anticipation
    #  if start>Payroll.farthestcalculabledate
    return unless start > Bankpayment.fartheststartdate
    errors.add(:start, :may_not_be_in_anticipation)
  end

  def finish_may_not_be_in_anticipation
    return unless finish > Bankpayment.fartheststartdate

    errors.add(:finish, :may_not_be_in_anticipation)
  end

  def start_must_be_prior_to_registration_cancellation_date
    return unless registration.cancelled? && (start > registration.accreditation.revocation)
    errors.add(:start, :may_not_occur_after_cancellation)
  end

  def finish_must_be_prior_to_registration_cancellation_date
    return unless  registration.present? && (finish > registration.accreditation.revocation)
    errors.add(:finish, :may_not_occur_after_cancellation)
  end

  def finish_cannot_be_prior_to_start
    return unless finish.present? && start.present? && finish < start
    errors.add(:finish, :may_not_be_prior_to_start)
  end

  # Event is not vacation
  def self.not_vacation
    where.not(id: vacation)
  end

  # Event is vacation
  def self.vacation
    joins(:leavetype).merge(Leavetype.vacation)
  end

  def self.days_vacationed(r)
    total_days = 0

    Event.vacation.for_registration(r).each do |e|
      total_days += e.numdays
    end

    total_days
  end


  def self.chronologically
    # order(:daystarted, :dayfinished)

    joins(registration: { student: :contact }).order(:start, :finish, 'contacts.name')
  end

  def self.ordered_for_payroll_display
    order(start: :asc)
  end

  def self.ordered_by_contact_name
    joins(registration: { student: :contact }).order('contacts.name')
  end

  def self.ordered_by_institution_and_contact_name
    joins(registration: [student: [contact: { user: :institution }]])
      .order('institutions.name', 'contacts.name')
  end

  # New for 2017, to track overflown events
  def self.out_of_context_on(dt)
    where.not(id: contextual_on(dt))
  end

  def self.contextual_on(dt)
    registration_ids_contextual = Registration.contextual_on(dt)

    where(registration_id: registration_ids_contextual)
  end

  # Hotfix - August 30 - 2017
  # Marcelo
  def registration_full_details
    registration_details
  end

  def registration_details
    registration.name_ids_schoolyear_institution_abbrv
  end

  def prefix
    event_prefix = if leave?

                     I18n.t('activerecord.models.leave').capitalize + ' ' + leavetype.name + ' '

                   else

                     I18n.t('activerecord.attributes.event.absence')

                   end

    event_prefix
  end

  def num_additional_months_spanned
    # It is assumed (i.e. validations enforce) that finish is not before start
    future_years_offset = (finish.year - start.year) * 12
    event_months_spanned = finish.month - start.month + future_years_offset

    event_months_spanned
  end

  def spans_additional_months?
    num_additional_months_spanned.positive?
  end

  def span
    event_span = '(' + I18n.l(start, format: :compact)
    event_span += if finish.present?

                    ' ' + I18n.t('until') + ' ' + I18n.l(finish, format: :compact) + ')'

                  else

                    ')'
                  end

    event_span
  end

  def name
    prefix + ' ' + span
  end

  def self.leave
    where.not(id: absence)
  end

  def self.paid_leave
    leave.joins(:leavetype).merge(Leavetype.paid)
  end

  # Event is not paid leave, i.e. unpaid leave *or* regular absences
  def self.not_paid_leave
    where.not(id: paid_leave)
  end

  def self.absence
    where(absence: true)
  end

  def self.regular_absence
    absence.actual
  end

  # Gets actual absences for a registration
  # Includes absences and unpaid leaves and filter for residuals
  def self.with_actual_absences_for(r)
    ordinary.not_paid_leave.for_registration(r)
  end

  # Must be filtered first
  # Calculate total absences (actual or due to financial situation)
  def self.absences_total
    total_absences = 0

    absence.each do |event|
      total_absences += event.numdays
    end

    total_absences
  end

  # Added for local admin training
  def self.confirmed
    where(confirmed: true)
  end

  # Not confirmed - authorization by managers pending (e.g. paid leave)
  def self.pending
    where.not(id: confirmed)
  end

  # Mostly due to late registrations or cancellations, suspensions
  def self.residual
    where(residual: true)
  end

  # Not residual
  def self.ordinary
    where.not(id: residual)
  end

  def finished?
    finish_date_exists? && regular? && registration_cancelled?
  end

  # Pending
  def pending?
    !confirmed
  end

  # e.g. Actual (non residual) absences
  def actual?
    !residual
  end

  # Result of an automatic computation, due to: late registration cancellations,
  # Obs: suspended and renewed (accreditations) not currently used
  def residual?
    residual
  end

  def absence?
    absence
  end

  def leave?
    !absence
  end

  def self.limited_leave
    joins(:leavetype).merge(Leavetype.limited)
  end

  def limited_leave?
    if leavetype.present? && leavetype.limited?

      true

    else

      false

    end
  end

  def unpaid?
    if unpaid_leave? || absence?

      true

    else

      false

    end
  end

  def paid_leave?
    if leavetype.present? && leavetype.paid?

      true

    else

      false

    end
  end

  def unpaid_leave?
    if leavetype.present? && !leavetype.paid?

      true

    else

      false

    end
  end

  def rigid_leave?
    if leavetype.present? && leavetype.rigid?

      true

    else

      false

    end
  end

  def occurs_within_the_same_calendar_month?
    !spans_additional_months?
  end
  # After subtracting limited leave, if applicable

  # To do
  # def actual_days

  #  end

  def self.for_institution(_i)
    # 	Event.joins(registration: [ student: [ contact: [ {user: :institution}]]])
  end

  def self.for_registration_from_payroll(r, p)
    for_registration(r).for_payroll(p)
  end

  # Alternate syntax - See report annotations show view
  def self.for_registration_from_payroll_period(r, p)
    for_registration(r).for_payroll_period(p)
  end

  def self.most_recent_finish_date_for_registration(r)
    for_registration(r).pluck(:finish).max
  end

  def self.for_registration(r)
    joins(:registration).where(registration_id: r.id)
  end

  # Vacation periods
  def self.vacations_for_registration(r)
    for_registration(r).vacation
  end

  # Day started - as integer
  #     start.to_datetime.to_i/(3600*24)
  def student_institution
    registration.student.contact.user.institution
  end

  def student_institution_id
    student_institution.id
  end

  def report_details
    I18n.l(start, format: :compact)
  end

  def self.registration_ids_for_payroll(p)
    for_payroll(p).pluck(:registration_id).uniq
  end

  # Events prior to the current payroll - Useful for total absences calculations
  def self.before_payroll(p)
    where('daystarted < ? ', p.daystarted)
  end

  # Which starts after the latest done payroll
  def self.recent
    where('start > ? ', Bankpayment.latestdone.payroll.monthworked.next_month)
  end

  # i.e. Able to be archived
  def self.historic
    where.not(id: recent)
  end

  # Recent event, started after the latest done payroll
  def recent?
    start > Bankpayment.latestdone.payroll.monthworked.next_month
  end

  # From a previously processed (i.e. bankpayment performed, done=true) payroll
  def historic?
    !recent?
  end

  # New method, added for PDF report
  def self.from_institution(i)
    joins(registration: { student: { contact: { user:
    :institution } } }).where('institutions.id = ? ', i.id)
  end

  # Events from students registered at the institution
  # Ransackable
  def self.for_institution_id(i)
    joins(registration: { student: { contact: { user:
    :institution } } }).where('institutions.id = ? ', i)
  end

  # Ransackable
  def self.for_schoolterm_id(s)
    joins(registration: :schoolterm).where('schoolterms.id = ? ', s)
  end

  # This assumes they payroll cycle is the entire month.
  # Returns events which occurred in a calendar month
  def self.on_month(m)
    first_of_month = m.beginning_of_month
    dfirst = (first_of_month - Settings.dayone).to_i # First day of the month
    dlast = (first_of_month.next_month - Settings.dayone - 1).to_i # Last day of the month

    where('daystarted >= ? and dayfinished <= ? ', dfirst, dlast)
  end

  # ids for institutions with one or more event
  def self.institution_ids
    joins(registration: { student: { contact: { user:
      :institution } } }).pluck(:institution_id).uniq.sort
  end

  def registration_cancelled?
    if registration.present? && registration.revoked?

      true

    else

      false

    end
  end

  # For ransack search
  def self.for_payroll_id(p)
    payroll = Payroll.find(p)

    where('dayfinished >= ? and daystarted <= ? ', payroll.daystarted, payroll.dayfinished)
  end

  def self.for_payroll(p)
    #  	where("dayfinished >= ? and daystarted <= ? ",p.daystarted, p.dayfinished)
    # New for 2017
    where('dayfinished >= ? and daystarted <= ? ',
          p.daystarted, p.dayfinished).contextual_on(p.monthworked)
  end

  # Out of payroll's context - To warn managers and admin
  def self.out_of_payroll_context(p)
    #  	where("dayfinished >= ? and daystarted <= ? ",p.daystarted, p.dayfinished)
    # New for 2017
    where('dayfinished >= ? and daystarted <= ? ',
          p.daystarted, p.dayfinished).out_of_context_on(p.monthworked)
  end

  # Alternate method.  Uses date instead of integers.  Used to fix payroll (annotations) report.
  def self.for_payroll_period(p)
    where('start <= ? AND finish >=? ', p.finish, p.start)
  end

  # Computes actual absences for a registration
  def self.regular_absences_for(r)
    events = not_paid_leave.actual.for_registration(r)
    # Includes absences and unpaid leaves and filter for residuals

    total_num_days = 0

    events.each do |event|
      total_num_days += event.numdays
    end

    total_num_days
  end

  def self.ids_started_on_a_previous_payroll
    Event.started_on_a_previous_payroll.pluck(:id)
  end

  def self.started_on_a_previous_payroll
    current_payroll = Payroll.latest.first

    current_payroll_start_date = current_payroll.start
    #    @previous_payroll = Payroll.where(paymentdate: '2017-8-10').first

    @previous_payroll = Payroll.previous.first

    Event.where('start < ?', current_payroll_start_date)
  end

  private

  def start_is_date?
    errors.add(:start, 'must be a valid date') unless start.is_a?(Date)
  end
end

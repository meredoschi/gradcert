# frozen_string_literal: true

# Monthly scholarship recipients payroll
# IMPORTANT: Working month is assumed to start on the first calendar day
# i.e. Payroll cycle goes from the 1st to 28..31 depending on the Month/Year
class Payroll < ActiveRecord::Base
  has_paper_trail # Needed for auditing

  # http://stackoverflow.com/questions/1019939/ruby-on-rails-best-method-of-handling-currency-money
  monetize :amount_cents

  # ------------------- Associations ------------------------
  belongs_to :scholarship
  belongs_to :taxation
  has_many :annotation, dependent: :restrict_with_exception
  has_many :bankpayment, dependent: :restrict_with_exception
  has_many :feedback, dependent: :restrict_with_exception
  # ---------------------------------------------------------

  # ------------------- Validations -------------------------
  validates :comment, length: { maximum: 200 }
  validate :manual_amount
  %i[paymentdate taxation_id monthworked].each do |required_field|
    validates required_field, presence: true
  end

  validates :paymentdate, uniqueness: { unless: :special? }

  # validate :timely_payment

  #  def timely_payment
  #    errors.add(:paymentdate, :inconsistent) unless payment_on_the_usual_dt?
  #  end

  def manual_amount
    errors.add(:amount, :present) if scholarship_id.present? && amount.positive?
  end

  # ---------------------------------------------------------

  # ------------------- Class methods -----------------------

  def self.distinct_working_months
    pluck(:monthworked).uniq
  end

  def self.num_distinct_working_months
    distinct_working_months.count

    # To do: can can
  end

  def self.existence?
    num_distinct_working_months.positive?
  end

  def self.more_than_one_working_month_recorded?
    num_distinct_working_months > 1
  end

  def self.less_than_two_working_months_recorded?
    num_distinct_working_months < 2
  end

  def self.start_dt_corresponding_to_today
    # IMPORTANT! The payroll cycle goes from the first to the last calendar day in every month.
    Time.zone.today.beginning_of_month
  end

  # --- Contextual methods start

  def self.ids_contextual_on_sql(specified_dt)
    # Date represented in numeric format
    numeric_dt = Dateutils.regular_to_elapsed(specified_dt)

    query = 'select id from payrolls where id not in '\
    '(Select id from payrolls where daystarted > ? or dayfinished<?)'

    find_by_sql [query, numeric_dt, numeric_dt]
  end

  def self.ids_contextual_on(specified_dt)
    ids_contextual_on_sql(specified_dt)
  end

  def self.contextual_on_sql(specified_dt)
    # Date represented in numeric format
    numeric_dt = Dateutils.regular_to_elapsed(specified_dt)

    # Filter payrolls yet to start as well as those already completed
    query = 'select * from payrolls where id not in '\
    '(Select id from payrolls where daystarted > ? or dayfinished<?)'

    # This is written in plural form, for occasionally there may be special payrolls.
    # There should be at most one regular payroll per program area (e.g. medical residency).
    find_by_sql [query, numeric_dt, numeric_dt]
  end

  def self.ids_contextual_today
    ids_contextual_on(Time.zone.today)
  end

  # Contextual on a specified date - returns an active record relation
  # Only one payroll, per area, should exist.
  # Reminder: use .first to get the object
  def self.contextual_on(specified_dt)
    where(id: ids_contextual_on_sql(specified_dt))
  end

  def self.contextual_today
    #  where(id: ids_contextual_today) # active record version
    contextual_on(Time.zone.today)
  end

  # Alias, for convenience
  def self.current
    contextual_today
  end

  # --- Contextual methods finish

  def self.past
    where(id: past_ids_sql)
  end

  def self.past_ids_sql
    # Date represented in numeric format
    numeric_dt = Dateutils.regular_to_elapsed(Time.zone.today)

    # Filter payrolls yet to start as well as those already completed
    query = 'select id from payrolls where id in (Select id from payrolls where dayfinished<?)'

    # i.e. finish date has passed, but not necessarily completed (bank payment performed)
    find_by_sql [query, numeric_dt]
  end

  def self.actual
    where.not(id: planned)
  end

  # Future
  def self.planned
    where('monthworked > ?', start_dt_corresponding_to_today)
  end

  def self.newest_first
    order(dayfinished: :desc).distinct
  end

  def self.ordered_from_oldest_to_newest
    order(dayfinished: :asc).distinct
  end

  # Alias
  def self.ordered_by_most_recent
    ordered_by_monthworked_paymentdate_special_createdat_desc
  end

  def self.ordered_by_reference_month_desc
    order(monthworked: :desc)
  end

  def self.ordered_by_monthworked_paymentdate_special_createdat_desc
    order(monthworked: :desc, paymentdate: :desc, special: :desc, created_at: :desc)
  end

  def self.ordered_by_reference_month
    order(:monthworked)
  end

  def self.with_bankpayment
    joins(:bankpayment).distinct
  end

  # Closed, bank payment performed.
  def self.without_bankpayment
    where.not(id: with_bankpayment)
  end

  def self.with_annotations
    joins(:annotation).distinct
  end

  # Dec 2017
  # Obs: returns an activerecord relation
  # This may return nil if payrolls are created in advance of the cycle
  # (since they, logically, will not be completed yet)
  def self.latest_completed
    latest_completed_sql
  end

  # December 2019 - Implemented via raw sql
  # Usually returns a single record: the most recently completed payroll (if there are any)
  # Unless one or more special payrolls exist for the most recent payment date and reference month
  def self.latest_completed_sql
    query = 'WITH Completed_Payrolls_CTE(monthworked, paymentdate) '\
    'AS (select p.monthworked, p.paymentdate from payrolls p inner join bankpayments bp on'\
    '(p.id=bp.payroll_id) where bp.done=true)'\
    ','\
    'Latest_Completed_Payroll_CTE(monthworked, paymentdate) AS ('\
    'select * from Completed_Payrolls_CTE order by monthworked desc, paymentdate desc limit 1'\
    '),'\
    'Latest_Completed_Payroll_monthworked_CTE(monthworked) AS ('\
    'select monthworked from Latest_Completed_Payroll_CTE'\
    '),'\
    'Latest_Completed_Payroll_paymentdate_CTE(paymentdate) AS ('\
    'select paymentdate from Latest_Completed_Payroll_CTE'\
    ')'\
    'select * from Payrolls where monthworked '\
    'in (select monthworked from Latest_Completed_Payroll_monthworked_CTE) and '\
    'paymentdate in (select paymentdate from Latest_Completed_Payroll_paymentdate_CTE);'

    find_by_sql(query)
  end

  # i.e. with the most recent (or most in the future) finish date
  def self.newest
    order(:dayfinished).last
  end

  # Closed, bank payment performed.
  def self.completed
    joins(:bankpayment).merge(Bankpayment.done)
  end

  # Closed, bank payment performed.
  def self.incomplete
    #    where.not(id: completed)
    # New, after attribute was removed
    joins(:bankpayment).merge(Bankpayment.not_done)
  end

  # Payroll is not yet completed (closed).
  def self.active
    incomplete.contextual_today
  end

  # Find the information using sql (less portable, but generally faster than active record)
  # Provided for convenience
  def self.annotated_ids_sql
    # raw sql query
    query = 'SELECT distinct p.id FROM payrolls p INNER JOIN annotations a ON '\
    '(p.id = a.payroll_id);'
    find_by_sql(query)
  end

  def self.not_annotated_ids_sql
    # sql query
    query = 'select id from payrolls p2 where id not in (SELECT distinct p.id FROM payrolls p ' \
    'INNER JOIN annotations a ON (p.id = a.payroll_id));'
    find_by_sql(query) # payroll_ids_without_annotations
  end

  # Returns payrolls with at least one annotation - active record version (i.e. already calculated)
  def self.not_annotated
    where.not(id: annotated)
  end

  # Returns the ids for those payrolls with at least one annotation (via active record)
  def self.annotated_ids
    #    Payroll.joins(:annotation).pluck(:id).uniq
    annotated_ids_sql
  end

  # Returns payrolls with at least one annotation
  def self.annotated
    where(id: Payroll.annotated_ids)
  end

  def self.regular
    where(special: false)
  end

  def self.not_scheduled
    where.not(id: with_bankpayment)
  end

  def self.special
    where(special: true)
  end

  # Fix
  def self.pap
    where(pap: true, medres: false)
  end

  def self.medres
    where(medres: true, pap: false)
  end

  # Alias (formerly a boolean attribute)
  def self.done
    completed
  end

  # The last accountable day on the previous payroll (if it exists)
  def self.previous_dt_finished
    if previous_payrolls.present?
      previous_payroll = previous_payrolls.first # active record object, first is needed here
      dt_finished = Dateutils.to_gregorian(previous_payroll.dayfinished)
    end

    dt_finished
  end

  # Alias to current
  def self.latest
    current
  end

  def self.reference_month_most_in_the_future
    order(monthworked: :desc).first.monthworked
  end

  # Returns an active record relation
  def self.with_reference_month_most_in_the_future
    where(monthworked: reference_month_most_in_the_future)
  end

  # Returns the most recently completed (regular) payroll, if any
  def self.previous
    query = 'WITH Completed_Payrolls_CTE(monthworked, paymentdate) AS '\
    '(select p.monthworked, p.paymentdate from payrolls p inner join bankpayments bp on '\
    '(p.id=bp.payroll_id) where bp.done=true)'\
    ','\
    'Latest_Completed_Payroll_CTE(monthworked, paymentdate) AS ('\
    'select * from Completed_Payrolls_CTE order by monthworked desc, paymentdate desc limit 1'\
    '),'\
    'Latest_Completed_Payroll_monthworked_CTE(monthworked) AS ('\
    'select monthworked from Latest_Completed_Payroll_CTE'\
    ')'\
    'select * from Payrolls p where monthworked in '\
    '(select monthworked from Latest_Completed_Payroll_monthworked_CTE) and p.special=false;'

    find_by_sql(query)
  end

  # Last day of the payroll which is most in the future
  def self.farthestaccountabledate
    farthestaccountabledate_sql
  end

  # Last day of the payroll which is most in the future
  # Active record version - more portable
  def self.farthestaccountabledate_activerec
    Dateutils.elapsed_to_regular_date(maximum(:dayfinished))
  end

  # Returns a date object (if at least one payroll exists)
  def self.farthestaccountabledate_sql
    return unless count.positive?

    query = 'WITH max_dt(monthworked) AS (Select monthworked from payrolls '\
    'order by monthworked desc limit 1)'\
    ', farthest_finish(tm) '\
    "as(select monthworked + interval '1 month' - interval '1 day' from max_dt) "\
    'select tm::date as farthest_calculable_payroll_dt from farthest_finish'
    result = ActiveRecord::Base.connection.execute(query)
    result.values[0][0].to_date
  end
  # ---------------------------------------------------------

  # ---------------- Instance methods -----------------------

  # Expressed as a date range (start to finish)
  def range
    start..finish
  end

  def prefix
    special_prefix = ''

    if special?
      special_prefix = '*' + I18n.t('activerecord.attributes.payroll.special') \
      + ' *  [' + comment + '] '
    end

    special_prefix
  end

  # Short version of name
  def shortname
    payroll_short_name = I18n.l(monthworked, format: :my) \
    + ' (' + I18n.l(paymentdate, format: :compact) + ')'

    payroll_short_name += ' *' + I18n.t('activerecord.attributes.payroll.special') + '*' if special?

    payroll_short_name
  end

  def pap?
    pap
  end

  def medres?
    medres
  end

  def name
    @payroll_name = if pending?

                      I18n.l(monthworked, format: :my) + ' *' + I18n.t('pending') + '*'

                    else

                      shortname

                    end

    @payroll_name
  end

  def is_annotated?
    @status = false

    @status = true if annotated

    @status
  end

  def not_annotated?
    !is_annotated?
  end

  # Sector (area, division, department) which the payroll belongs to (e.g. PAP, Medres)
  def sector
    txt = I18n.t('activerecord.attributes.payroll.pap') if pap?

    txt = I18n.t('activerecord.attributes.payroll.medres') if medres?

    txt
  end

  #   validate :payment_date_is_consistent, unless: :special?

  def payment_date_consistent?
    return unless monthworked.present? && paymentdate.present?

    monthworked.beginning_of_month == paymentdate.beginning_of_month.last_month
  end

  # Performs validations unless payroll is special
  # -------------------------------------------------------

  # i.e. With at least one event
  def with_events?
    events.exists?
  end

  # New - July 2017
  def events
    Event.for_payroll(self)
  end

  # Pending events for payroll
  def pending_events
    events.pending
  end

  # i.e. with events pending
  def pending?
    pending_events.count.positive?
  end

  def confirmed?
    !pending?
  end

  # Get the appropriate scholarship (i.e. amount) for the month worked
  # This way, cost of living adjustments (if applicable) are handled properly
  def scholarships_on_month
    Scholarship.on_month(monthworked) # numdays = virtual attribute
  end

  # Starting day in numeric format.  Number of days since application's "epoch"
  def start
    monthworked.beginning_of_month
  end

  def finish
    monthworked.end_of_month
  end

  # If done = true, complemented = true.
  def completed?
    done?
  end

  # If done is false, return true.  And vice-versa.
  def incomplete?
    # To do: fix this
    !done?
  end

  def cycle
    start..finish
  end

  # Payment could be done or still in progress.  This merely checks existence.
  def with_bankpayment?
    bankpayment.exists?
  end

  def without_bankpayment?
    !with_bankpayment?
  end

  def regular?
    !special
  end

  def special?
    special
  end

  # Expressed as a range (to define when institutions are allowed to enter payroll events)
  # Refers to local admins.
  # Restriction to be implemented on both welcome view and ability.rb
  # TDD

  def dataentryperiod
    dataentrystart..dataentryfinish
  end

  # TDD
  def dataentrypermitted?
    start = dataentrystart

    finish = dataentryfinish

    return false unless start.present? && finish.present?

    right_now = Time.zone.now

    Logic.within?(start, finish, right_now) # convenience method -returs a boolean
  end

  def done?
    is_payroll_done = if bankpayment.exists? && bankpayment.done == true
                        true
                      else
                        false
                      end

    is_payroll_done
  end

  def done
    done?
  end

  def details
    month_worked_i18n = I18n.t('activerecord.attributes.payroll.monthworked')
    payment_date_i18n = I18n.t('activerecord.attributes.payroll.paymentdate')
    amount_i18n = I18n.t('activerecord.attributes.payroll.amount')
    special_i18n = I18n.t('activerecord.attributes.payroll.special')
    sep = Settings.separator + ' '
    payroll_details = '[' + id.to_s + ']' + sep + \
                      month_worked_i18n + ': ' + I18n.l(monthworked) + sep + \
                      payment_date_i18n + ': ' + I18n.l(paymentdate) + sep + \
                      amount_i18n + ': ' + amount_cents.to_s + sep + \
                      special_i18n + ': ' + special.to_s
    payroll_details
  end

  def payment_on_the_usual_dt?
    customary_payment_dt = monthworked + \
                           Settings.payroll.payday.days_following_month_worked.days + 1.month

    is_payment_on_the_customary_dt = paymentdate == customary_payment_dt

    is_payment_on_the_customary_dt
  end
end

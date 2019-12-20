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
  has_many :bankpayment
  has_many :feedback
  # ---------------------------------------------------------

  # ------------------- Validations -------------------------
  validates :comment, length: { maximum: 200 }
  validate :manual_amount
  %i[paymentdate taxation_id monthworked].each do |required_field|
    validates required_field, presence: true
  end

  validates_uniqueness_of :paymentdate, unless: :special?

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
    Date.today.beginning_of_month
  end

  # --- Contextual methods start

  def self.ids_contextual_on(specified_dt)
    contextual_ids = []

    dt_range = specified_dt..specified_dt

    Payroll.all.each do |payroll|
      payroll_start = Dateutils.to_gregorian(payroll.daystarted)
      payroll_finish = Dateutils.to_gregorian(payroll.dayfinished)

      payroll_range = payroll_start..payroll_finish # Payroll cycle

      next unless Logic.intersect(dt_range, payroll_range) == dt_range

      contextual_ids << payroll.id
    end

    contextual_ids
  end

  def self.ids_contextual_today
    ids_contextual_on(Date.today)
  end

  # Contextual on a specified date - returns an active record relation
  # Only one payroll, per area, should exist.
  # Reminder: use .first to get the object
  def self.contextual_on(specified_dt)
    where(id: ids_contextual_on(specified_dt))
  end

  def self.contextual_today
    where(id: ids_contextual_today)
  end

  # Alias, for convenience
  def self.current
    contextual_today
  end

  # --- Contextual methods finish

  def self.past
    possible_current_payrolls = Payroll.current

    previous_payrolls = nil

    if possible_current_payrolls.present? # not nil

      # It is assumed payrolls are either of type pap or medical residency (but not both)
      # Future to do: add gradcert (boolean field) to the model
      current_payroll = possible_current_payrolls.first
      current_month_worked = current_payroll.monthworked
      previous_payrolls = Payroll.where('monthworked < ?', current_month_worked)

    end

    previous_payrolls
  end

  def self.actual
    where.not(id: planned)
  end

  # Future
  def self.planned
    where('monthworked > ?', start_dt_corresponding_to_today)
  end

  def self.newest_first
    order(dayfinished: :desc).uniq
  end

  def self.ordered_from_oldest_to_newest
    order(dayfinished: :asc).uniq
  end

  # Alias
  def self.ordered_by_most_recent
    ordered_by_reference_month_desc
  end

  def self.ordered_by_reference_month_desc
    order(monthworked: :desc)
  end

  def self.ordered_by_payment_date_reference_month_desc
    order(paymentdate: :desc, monthworked: :desc, special: :desc, created_at: :desc)
  end

  def self.ordered_by_reference_month
    order(:monthworked)
  end

  def self.with_bankpayment
    joins(:bankpayment).uniq
  end

  # Closed, bank payment performed.
  def self.without_bankpayment
    where.not(id: with_bankpayment)
  end

  def self.with_annotations
    joins(:annotation).uniq
  end

  # Dec 2017
  # Obs: returns an activerecord relation
  # This may return nil if payrolls are created in advance of the cycle
  # (since they, logically, will not be completed yet)
  def self.latest_completed
    latest.completed
  end

  # i.e. with the most recent (or most in the future) finish date
  def self.newest
    order(:dayfinished).last
  end

  def self.scheduled
    joins(:bankpayment)
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
    where(done: false)
  end

  # Events (automatically) computed into annotations
  def self.annotated
    where(annotated: true)
  end

  # Not calculated yet.
  def self.not_annotated
    where.not(id: annotated)
  end

  def self.regular
    where.not(id: special)
  end

  def self.not_scheduled
    where.not(id: scheduled)
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

  def self.numeric_ranges_by_id
    order(:id).pluck(:id, :daystarted, :dayfinished)
  end

  def self.ranges_by_id
    date_ranges_by_id = []

    numeric_ranges_by_id.each do |payroll_dates|
      payroll_dates[1] = Settings.dayone + payroll_dates[1].to_i # start
      payroll_dates[2] = Settings.dayone + payroll_dates[2].to_i # finish
      date_ranges_by_id << payroll_dates
    end

    date_ranges_by_id
  end

  # RSPEC --- to do
  # Returns latest finish date (i.e. pertaining to the most recent payroll)
  def self.latest_finish_date
    pluck(:dayfinished).max if count.positive?
  end

  # Fixed, december 2017: where(done: true)
  def self.done
    joins(:bankpayment).merge(Bankpayment.done)
  end

  # Latest payroll(s)
  def self.latest
    where(dayfinished: latest_finish_date) if count.positive?
  end

  # Important: This assumes payroll is from the beginning to the end of the month
  # Farthest finish date
  def self.latestfinishdate
    done.latest.first.monthworked.end_of_month
  end

  def self.reference_month_most_in_the_future
    Payroll.order(monthworked: :desc).first.monthworked
  end

  # Returns an active record relation
  def self.with_reference_month_most_in_the_future
    Payroll.where(monthworked: Payroll.reference_month_most_in_the_future)
  end

  # Previous month's payroll
  def self.previous
    #  if pluck(:monthworked).uniq.count > 1 # i.e. there is more than one month worked
    return unless more_than_one_working_month_recorded?

    most_recent = []
    most_recent << latest_finish_date
    before_latest = (pluck(:dayfinished) - most_recent).max
    where(dayfinished: before_latest)
  end

  # Last day of the payroll which is most in the future
  def self.farthestcalculabledate
    latest.first.monthworked.end_of_month
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

  def payment_date_coherent
    errors.add(:paymentdate, :inconsistent) unless payment_date_consistent?
  end

  # Sector (area, division, department) which the payroll belongs to (e.g. PAP, Medres)
  def sector
    txt = I18n.t('activerecord.attributes.payroll.pap') if pap?

    txt = I18n.t('activerecord.attributes.payroll.medres') if medres?

    txt
  end

  # To test -->
  #   validate :payment_date_is_consistent, unless: :special?

  # validate :payment_date_coherent

  # Tested code end

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

  def referencemonth
    I18n.l(monthworked, format: :my)
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
    done
  end

  # If done is false, return true.  And vice-versa.
  def incomplete?
    # To do: fix this
    !done
  end

  def cycle
    start..finish
  end

  # Payment could be done or still in progress.  This merely checks existence.
  def with_bankpayment?
    bankpayment.exists?
  end

  def without_bankpayment?
    !with_bankpayment
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

    right_now = Time.now

    Logic.within?(start, finish, right_now) # convenience method -returs a boolean
  end
end

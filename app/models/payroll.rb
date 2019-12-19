# frozen_string_literal: true

# Monthly scholarship recipients payroll
# IMPORTANT: Working month is assumed to start on the first calendar day
# i.e. Payroll cycle goes from the 1st to 28..31 depending on the Month/Year
class Payroll < ActiveRecord::Base
  # ------------------- References ------------------------

  belongs_to :taxation

  belongs_to :scholarship

  #   has_many  :supervisor, :foreign_key => 'contact_id'

  #    has_one :bankpayment

  #  Changed here!

  has_paper_trail

  has_many :bankpayment

  has_many :feedback

  validates_uniqueness_of :paymentdate, unless: :special?

  %i[paymentdate taxation_id monthworked].each do |required_field|
    validates required_field, presence: true
  end

  validates :comment, length: { maximum: 200 }

  # No longer used - Use scholarship table instead
  #    validates :amount, presence: true, numericality: { greater_than: 0 }, if: :special?

  #    validates :scholarship_id, presence: true, unless: :special?

  #     validates :scholarship_id, absence: true, if: :special?

  # *****************  Rspec - Tests - July 2017

  # Marcelo - December 2017 - Tested code

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

  # --- RSPEC block finish

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

  def self.past
    current_reference_month = Payroll.current.first.monthworked
    where('monthworked < ?', current_reference_month)
  end

  def self.actual
    all
    #    where.not(id: planned)
  end

  # Future
  def self.planned
    #    current_reference_month=Payroll.current.first.monthworked
    #    if current_reference_month?
    #     where("monthworked > ?", current_reference_month)
    #    else
    #    nil
    #    end
    nil
  end

  # --- SCOPES

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
  # ---

  # Expressed as a date range (start to finish)

  def range
    start..finish
  end

  def prefix
    @txt = ''

    if special?
      @txt = '*' + I18n.t('activerecord.attributes.payroll.special')
      @txt += ' *  [' + comment + '] '

    end

    @txt = ''
  end

  def self.more_than_one_working_month_recorded?
    num_distinct_working_months > 1
  end

  def self.existence?
    num_distinct_working_months.positive?
  end

  # Short version of name
  def shortname
    txt = ''

    txt += I18n.l(monthworked, format: :my)

    txt += ' ('
    txt += I18n.l(paymentdate, format: :compact) + ')'

    txt += ' *' + I18n.t('activerecord.attributes.payroll.special') + '*' if special?

    txt
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

  def self.num_distinct_working_months
    distinct_working_months.count

    # To do: can can
  end

  def self.distinct_working_months
    pluck(:monthworked).uniq
  end

  # Day started - as integer

  def dstart
    start.to_datetime.to_i / (3600 * 24)
  end

  # Day finished - as integers

  def dfinish
    finish.to_datetime.to_i / (3600 * 24)
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

  # Previous month's payroll
  def self.previous
    #  if pluck(:monthworked).uniq.count > 1 # i.e. there is more than one month worked
    return unless more_than_one_working_month_recorded?

    most_recent = []
    most_recent << latest_finish_date
    before_latest = (pluck(:dayfinished) - most_recent).max
    where(dayfinished: before_latest)
  end

  validate :manual_amount

  # Performs validations unless payroll is special

  # -------------------------------------------------------

  # http://stackoverflow.com/questions/1019939/ruby-on-rails-best-method-of-handling-currency-money

  monetize :amount_cents

  has_many :annotation, dependent: :restrict_with_exception

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

  def manual_amount
    errors.add(:amount, :present) if scholarship_id.present? && amount.positive?
  end

  def self.scheduled
    joins(:bankpayment)
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

  # Fix
  def self.pap
    where(pap: true, medres: false)
  end

  def self.medres
    where(medres: true, pap: false)
  end
  # ---

  # Last day of the payroll which is most in the future
  def self.farthestcalculabledate
    latest.first.monthworked.end_of_month
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

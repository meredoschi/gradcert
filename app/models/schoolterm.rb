# frozen_string_literal: true

# School calendar from first day of classes to the last
# As a general rule, events are limited to the same schoolterm
class Schoolterm < ActiveRecord::Base
  # ------------------- References ------------------------

  has_many :program, foreign_key: 'schoolterm_id',
                     dependent: :restrict_with_exception, inverse_of: :schoolterm

  #   has_many  :registration, :foreign_key => 'schoolterm_id'  - deprecated

  # -------------------------------------------------------

  has_many  :placesavailable, foreign_key: 'schoolterm_id',
                              dependent: :restrict_with_exception, inverse_of: :schoolterm

  has_many  :roster, foreign_key: 'schoolterm_id',
                     dependent: :restrict_with_exception, inverse_of: :schoolterm

  has_paper_trail

  def area
    if pap?
      I18n.t('activerecord.attributes.program.pap')
    elsif medres?
      I18n.t('activerecord.attributes.program.medres')
    else
      I18n.t('undefined')
    end
  end

  def details
    #  Schoolterm(id: integer, start: date, finish: date, pap: boolean, medres: boolean,
    #  registrationseason: boolean, scholarshipsoffered: integer, seasondebut: datetime,
    #  seasonclosure: datetime, admissionsdebut: datetime, admissionsclosure: datetime)
    sep = Settings.separator + ' '

    i18n_from = I18n.t('from')
    i18n_to = I18n.t('to')
    admissions_i18n = I18n
                      .t('activerecord.attributes.schoolterm.virtual.admissionsdatareportingperiod')
    registration_season_i18n = I18n.t('activerecord.attributes.schoolterm.registrationseason')

    term_start_finish_dts = I18n.l(start) + ' ' + i18n_to + ' ' + I18n.l(finish)
    registration_season_debut_closure_dts = registration_season_i18n + ' ' + i18n_from + ' ' \
     + I18n.l(seasondebut) + ' ' + i18n_to + ' ' + I18n.l(seasonclosure)
    admissions_debut_closure_dts = admissions_i18n + ' ' + i18n_from + ' ' \
     + I18n.l(admissionsdebut) + ' ' + i18n_to + ' ' + I18n.l(admissionsclosure)

    term_details = term_start_finish_dts + ' ' + sep + registration_season_debut_closure_dts \
     + ' ' + sep + admissions_debut_closure_dts

    term_details
  end

  def admissions_data_entry_period?
    @program_admissions_data_entry_period = false

    if admissionsdebut.present? && admissionsclosure.present?
      @program_admissions_data_entry_period = Logic
                                              .within?(admissionsdebut,
                                                       admissionsclosure, Time.zone.now)
    end

    @program_admissions_data_entry_period
  end

  def in_season?
    Logic.within?(seasondebut, seasonclosure, Time.zone.now) # returs a boolean
  end

  # ---------------------------------------------------------------------------------------------

  #
  # For 2017 registration season

  # i.e. Active, in progress
  def self.ids_active_today
    ids_active_on(Time.zone.today)
  end

  # Preferred naming (to avoid confusion with active or inactive registrations)
  # Alias
  def self.ids_contextual_on(specified_dt)
    ids_active_on(specified_dt)
  end

  # Alias
  def self.ids_contextual_today
    ids_active_today
  end

  # Convenience method
  def self.contextual_today
    contextual_on(Time.zone.today)
  end

  # Alias
  # Preferred naming.  Active will become deprecated.
  def self.contextual_on(specified_dt)
    where(id: ids_active_on(specified_dt))
  end

  # More generic version of active_today
  # specified_dt = specified date
  def self.ids_active_on(specified_dt)
    all_terms = all

    active_ids = []

    dt_range = specified_dt..specified_dt

    all_terms.each do |term|
      term_range = term.start..term.finish # Schoolterm

      next unless Logic.intersect(dt_range, term_range) == dt_range

      active_ids << term.id
    end

    active_ids
  end

  # Registration season open a specified date
  def self.ids_within_registration_season(specified_dt)
    all_terms = all

    active_ids = []

    dt_range = specified_dt..specified_dt

    all_terms.each do |term|
      next unless term.seasondebut.present? && term.seasonclosure.present?

      term_range = term.seasondebut.to_date..term.seasonclosure.to_date # Schoolterm
      next unless Logic.intersect(dt_range, term_range) == dt_range

      active_ids << term.id
    end

    active_ids
  end

  # specified_dt = arbitrary date
  # It is assumed season debut and closure are consistent
  # i.e. have been properly validated and are within start and finish
  def within_registration_season?(specified_dt)
    dt_range = specified_dt..specified_dt

    term_range = seasondebut.to_date..seasonclosure.to_date # Schoolterm

    (seasondebut.present? && seasonclosure.present? &&
       Logic.intersect(dt_range, term_range) == dt_range)
  end

  def self.registrations_allowed_and_within_season(specified_dt)
    within_registration_season(specified_dt).allowed
  end

  # Within the registration season
  def self.within_registration_season(specified_dt)
    where(id: ids_within_registration_season(specified_dt))
  end

  # Active today (special case)
  def self.active_today
    where(id: ids_active_today)
  end

  # Active on a specified date
  def self.active_on(specified_dt)
    where(id: ids_active_on(specified_dt))
  end

  def previous
    previous_term = Schoolterm.where(start: start - 1.year)

    return unless previous_term.exists?

    previous_term
  end
  #   return self.where(id: actual_ids)

  # To do: implement this more generally, with intersect
  # This assumes schoolterm begins on March 1st !
  def self.for_payroll(payroll)
    reference_year = if payroll.monthworked.month > 2

                       payroll.monthworked.year

                     else

                       payroll.monthworked.year - 1

                     end

    month_day = '-03-01'

    first_day_of_classes = reference_year.to_s + month_day

    find_by start: first_day_of_classes
  end

  # Returns latest finish date (i.e. pertaining to the most recent)
  def self.latest_finish_date
    pluck(:finish).max if count.positive?
  end

  # Returns earliest finish date (i.e. pertaining to the earliest)
  def self.earliest_finish_date
    pluck(:finish).min if count.positive?
  end

  # Latest - most recent
  # Returns active record relation - Used in placesavailable view
  def self.most_recent
    where(finish: latest_finish_date) if count.positive?
  end

  # Earliest, chronologically the oldest
  # Builds on the logic by the latest
  # Returns active record relation - Used in placesavailable view
  def self.earliest
    where(finish: earliest_finish_date) if count.positive?
  end

  # Latest - most recent (returs individual record)
  def self.latest
    find_by finish: latest_finish_date if count.positive?
  end

  def name
    I18n.t('activerecord.attributes.schoolterm.start') + ' ' + I18n.l(start, format: :compact)
  end

  def startdate
    I18n.l(start)
  end

  # Used in legal form, registrations controller
  def contract_last_day
    start + 1.year - 1 # One year in the future minus one day
  end

  def self.firstday_active
    contextual_today.pluck(:start).min
  end

  def self.lastday_active
    contextual_today.pluck(:finish).max
  end

  def self.lastday
    lastday_all
  end

  def self.firstday
    firstday_all
  end

  def self.lastday_all
    pluck(:finish).max
  end

  def self.firstday_all
    pluck(:start).min
  end

  def self.active
    where(active: true)
  end

  # --- Model finders
  def self.find_active_schoolterms
    where(active: true)
  end

  # Returns active record relation
  # It is assumed there will be only one
  def self.current
    active.order(:finish).first
  end

  def self.not_current
    where.not(id: current)
  end

  def self.registrations_closed
    where.not(id: open)
  end

  # To do: review this
  # Important!  This assumes there is only one schoolterm open which is
  # more recent than the current open term in the same area (pap, medres)
  # This is used for new program creation (during registration season)
  # or in rare circumstances editing a current program's characteristics.

  # Refer to _form_schoolterm partial on programs
  def self.current_or_next
    where('start >= ? ', current.start)
  end

  # To do: fix this - to use dates properly
  def self.open_season?
    allowed.exists?
  end

  # Registration season open
  def self.allowed
    where(registrationseason: 'true')
  end

  # Previous, not active or open (newest)
  def self.past
    where.not(id: current)
  end

  # To do - fix this
  # Registration season open
  def allowed?
    registrationseason # && within_admissions_data_entry_period
  end

  # To do - fix this
  # Registration season open
  def open?
    allowed?
  end

  # Returns a single record
  # However, in reality this has limited usefulness since registration season
  # varies by area and begins before the next term becomes active
  # One might do: limit area visibility by using ability and use a helper method for the form.
  def self.currently_active
    current.first
  end

  # Computes number of active schoolterms
  def self.num_active
    active.count
  end

  # Belonging to Pap
  def self.pap
    where(pap: true)
  end

  # Belonging to Medical Residency
  def self.medres
    where(medres: true)
  end

  def self.find_active_pap_schoolterms
    where(pap: true, active: true)
  end

  def self.find_active_medres_schoolterms
    where(medres: true, active: true)
  end

  # With annotations -- used to filter null Ransackable search (which was giving errors)
  def self.annotated
    joins(registration: :annotation).merge(Schoolterm.all).uniq
  end

  # Actually with at least 1 event
  # -- used to filter null Ransackable search (which was giving errors)
  def self.eventful
    joins(registration: :event).merge(Schoolterm.all).uniq
  end

  # Processed by SISPAP
  def self.modern
    where(' schoolterms.start >= ? ', Settings.operational_start)
  end

  # Processed by the legacy system (Pick)
  def self.legacy
    where.not(id: modern)
  end

  # New for 2017

  def active_today?
    Schoolterm.ids_contextual_today.include? id
  end

  def active_on?(specified_dt)
    Schoolterm.ids_contextual_on(specified_dt).include? id
  end

  # Alias, for clarity
  def active_as_of?(specified_dt)
    active_on?(specified_dt)
  end

  def active?
    active_today?
  end

  def self.default_scope
    order(start: :desc)
  end

  # Tests pending

  def self.ids_within_admissions_data_entry_period
    @ids_within_admissions_data_entry_period = []

    Schoolterm.all.find_each do |schoolterm|
      next unless schoolterm.admissions_data_entry_period?

      @ids_within_admissions_data_entry_period << schoolterm.id
    end

    @ids_within_admissions_data_entry_period
  end

  def self.within_admissions_data_entry_period
    where(id: ids_within_admissions_data_entry_period)
  end

  # Negative
  def self.admissions_data_entry_not_in_range
    where.not(id: within_admissions_data_entry_period)
  end
end

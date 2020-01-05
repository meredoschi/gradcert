# frozen_string_literal: true

class Accreditation < ActiveRecord::Base
  has_paper_trail

  belongs_to :program

  belongs_to :institution

  belongs_to :registration

  # hotfix - to close march payroll
  # Marcelo - Commented - January 2018
  #  before_validation :check_start_date
  #  after_validation :check_start_date
  #
  #  before_validation :check_start_date, on: :create

  # ---------- end comment
  # scopes

  scope :original, -> { where(original: true) }

  scope :renewed, -> { where(renewed: true) }

  scope :suspended, -> { where(suspended: true) }

  scope :revoked, -> { where(revoked: true) }

  scope :not_original, -> { where(original: false) }

  scope :not_renewed, -> { where(renewed: false) }

  scope :not_suspended, -> { where(suspended: false) }

  scope :not_revoked, -> { where(revoked: false) }

  scope :everyone, -> { where 'original=true or revoked=true' }

  # ----

  validates :comment, length: { maximum: 200 }

  validates_inclusion_of [:original], in: [true], unless: :renewal_revocation_or_suspension?

  validates :start, presence: true, if: :is_original_or_was_renewed?

  validates :start, presence: true, unless: :renewal_revocation_or_suspension?

  validates :renewal, presence: true, if: :was_renewed?

  validates :suspension, presence: true, if: :was_suspended?

  validates :revocation, presence: true, if: :was_revoked?

  validates_inclusion_of %i[renewed suspended revoked], in: [false], if: :is_original?

  validates_inclusion_of %i[original suspended revoked], in: [false], if: :was_renewed?

  validates_inclusion_of %i[original renewed revoked], in: [false], if: :was_suspended?

  validates_inclusion_of %i[original renewed suspended], in: [false], if: :was_revoked?

  # http://stackoverflow.com/questions/12825048/rails-pass-a-parameter-to-conditional-validation

  # validate :start_cannot_be_in_the_future, unless: :open? # Registrations have opened for the next schoolterm

  validate :registration_start_cannot_be_prior_to_first_day_in_schoolyear, if: :registration?

  #  validate :registration_start_cannot_be_prior_to_april_first, if: :registration?, on: :create?

  validate :renewal_cannot_be_in_the_future
  validate :suspension_cannot_be_in_the_future
  #   validate :revocation_cannot_be_in_the_future, unless: :open? # i.e. for next schoolterm - training setting

  validate :revocation_cannot_be_in_the_future, if: :registration?, unless: :registrations_open? # i.e. for next schoolterm - training setting

  validate :renewal_cannot_be_on_the_same_month_as_suspension
  validate :revocation_cannot_be_on_the_same_month_as_renewal

  validate :renewal_cannot_be_prior_to_start # or equal (i.e. or on the same day as)
  # validate :suspension_cannot_be_prior_to_start # or equal
  validate :revocation_cannot_be_prior_to_start, unless: :did_not_show?

  # validate :renewal_must_be_later_than_start

  validate :suspension_cannot_be_prior_to_renewal, if: :was_suspended?
  validate :revocation_cannot_be_prior_to_renewal, if: :was_revoked?

  validate :revocation_cannot_be_prior_to_suspension, if: :was_revoked?

  validates :revocation, absence: true, if: :was_not_revoked?

  %i[renewal suspension revocation].each do |n|
    validates n, absence: true, if: :is_original?
  end

  validate :suspension_cannot_be_more_recent_than_renewal, if: :was_renewed?

  validate :cancellation_date_must_be_after_latest_event_finish_date, if: :registration?

  validate :registration_revocation_cannot_overlap_completed_payrolls, if: :registration?

  #  validate :registration_not_possible_after_closing_date, if: :registration?

  # Tested code start

  def kind
    txt = ''

    txt += I18n.t('activerecord.models.program') if program?

    txt += I18n.t('activerecord.models.institution') if institutional?

    txt += I18n.t('activerecord.models.registration') if registration?

    txt
  end

  def info
    kind_i18n = I18n.t('of.n')
    accreditation_i18n = I18n.t('activerecord.models.accreditation').capitalize
    start_i18n = I18n.t('start')
    accr_info = accreditation_i18n + ' ' + kind_i18n + ' ' + kind \
    + ' [' + id.to_s + '] ' + start_i18n + ' ' + I18n.l(start)
    accr_info
  end

  def institutional?
    institution_id.present?
  end

  def program?
    program_id.present?
  end

  def registration?
    registration_id.present?
  end

  # Tested code end

  # Cancelled on the first day
  def did_not_show?
    revocation == start
  end

  def registration_not_possible_after_closing_date
    if start.present? && start >= registration_closed_from

      errors.add(:start, :not_possible_after_closing_date)

   end
  end

  def registration_start_cannot_be_prior_to_first_day_in_schoolyear
    if  start.present? && start < school_term.start # school_term=registration.schoolyear.program.schoolterm

      errors.add(:start, :may_not_be_prior_to_first_day_in_term)
     #   errors.add(:_, "Data de matrícula não pode ser anterior ao primeiro dia do ano letivo correspondente.")
   end
  end

  # quick block - hotfix
  def registration_start_cannot_be_prior_to_april_first
    if  start.present? && start < school_term.start + 1.month # school_term=registration.schoolyear.program.schoolterm

      errors.add(:start, :may_not_be_prior_to_april_first)
    end
  end

  def cancellation_date_must_be_after_latest_event_finish_date
    if Registration.count.positive? && Event.count.positive? && revocation.present?

      most_recent_event_date = Event.most_recent_finish_date_for_registration(registration)

      if most_recent_event_date.present? && revocation <= most_recent_event_date
        errors.add(:revocation, :cancellation_must_be_after_latest_event_finish_date)
       end

    end
  end

  # Confirmation pending - Entered by local administrators
  def self.pending
    where.not(id: confirmed)
  end

  # Entered or confirmed by managers (or eventually admin)
  def self.confirmed
    where(confirmed: true)
  end

  # Schoolterm which this accreditation pertains to
  def school_term
    registration.schoolyear.program.schoolterm if registration.present?
  end

  # Registrations whose situation is confirmed (i.e. created or updated by admin or manager)
  def self.registration_situation_confirmed
    joins(:registration).where(confirmed: true)
   end

  # Not confirmed, pending would be edited or created by local admins
  def self.registration_situation_pending
    joins(:registration).where(confirmed: false)
    #     where.not(id: self.registration_situation_confirmed)
  end

  # Registration season is open (i.e. future programs, next schoolterm)
  def registrations_open?
    registration.open?
  end

  # Date validation routines
  #  http://stackoverflow.com/questions/17935597/ruby-on-rails-i18n-want-to-translate-custom-messages-in-models
  # i18n Localized

  #    def renewal_must_be_later_than_start
  # distance in time
  #     if start.present? && renewal.present? & start == renewal
  #       errors.add(:renewal, :may_not_be_equal_to_start)
  #    end
  #  end

  def renewal_revocation_or_suspension?
    if renewal.present? || revocation.present? || suspension.present?

      true

    else

      false

    end
  end

  def registration_revocation_cannot_overlap_completed_payrolls
    if revocation.present? && revocation <= Accreditation.latest_completed_payroll_finish_date
      errors.add(:revocation, :may_not_overlap_completed_payrolls)
    end
  end

  def revocation_cannot_be_on_the_same_month_as_renewal
    if renewal.present? && revocation.present? && renewal.beginning_of_month == revocation.beginning_of_month
      errors.add(:revocation, :may_not_not_be_on_the_same_month_as_renewal)
    end
  end

  def renewal_cannot_be_on_the_same_month_as_suspension
    if suspension.present? && renewal.present? && suspension.beginning_of_month == renewal.beginning_of_month
      errors.add(:renewal, :may_not_not_be_on_the_same_month_as_suspension)
    end
  end

  def start_cannot_be_in_the_future
    errors.add(:start, :may_not_be_in_the_future) if start.present? && start > Date.today
  end

  def renewal_cannot_be_in_the_future
    errors.add(:renewal, :may_not_be_in_the_future) if renewal.present? && renewal > Date.today
  end

  def suspension_cannot_be_in_the_future
    if suspension.present? && suspension > Date.today
      errors.add(:suspension, :may_not_be_in_the_future)
    end
  end

  def suspension_cannot_be_more_recent_than_renewal
    if renewed? && suspension? && suspension > renewal
      errors.add(:suspension, :may_not_be_more_recent_than_renewal_if_renewed)
    end
  end

  def revocation_cannot_be_in_the_future
    if revocation.present? && revocation.present? && revocation > Date.today
      errors.add(:revocation, :may_not_be_in_the_future)
    end
  end

  def renewal_cannot_be_prior_to_start
    if start.present? && renewal.present? && renewal <= start
      errors.add(:renewal, :may_not_be_prior_to_start)
    end
  end

  def suspension_cannot_be_prior_to_start
    if suspension.present? && start.present? && suspension <= start
      errors.add(:suspension, :may_not_be_prior_to_start)
    end
  end

  def revocation_cannot_be_prior_to_start
    if revocation.present? && start.present? && revocation <= start
      errors.add(:revocation, :may_not_be_prior_to_start)
    end
  end

  def suspension_cannot_be_prior_to_renewal
    if suspension.present? && renewal.present? && suspension <= renewal
      errors.add(:suspension, :may_not_be_prior_to_renewal)
    end
   end

  def revocation_cannot_be_prior_to_renewal
    if revocation.present? && renewal.present? && renewal > revocation
      errors.add(:revocation, :may_not_be_prior_to_renewal)
    end
  end

  def revocation_cannot_be_prior_to_suspension
    if revocation.present? && suspension.present? && revocation < suspension
      errors.add(:revocation, :may_not_be_prior_to_suspension)
    end
  end

  def details_on_file?
    if original || renewed || suspended || revoked

      true

    else

      false

    end
   end

  # To do: fix this to work with Medical Residency as well.
  def self.latest_completed_payroll_finish_date
    Settings.dayone + Bankpayment.done.latest.payroll.dayfinished
   end

  def was_suspended?
    suspended == true
  end

  def was_revoked?
    revoked == true
  end

  def was_not_revoked?
    revoked == false
  end

  def was_renewed?
    renewed == true
  end

  def institutional?
    institution_id.present?
  end

  def program?
    program_id.present?
  end

  def registration?
    registration_id.present?
  end

  def is_original_or_was_renewed?
    original == true || renewed == true
  end

  # i.e. During the payroll's working (reference) month

  # cancelled = revoked

  def self.cancelled_on_this_payroll(p)
    where('revocation >= ? and revocation <= ?', p.start, p.finish)
  end

  def cancelled_on_this_payroll?(p)
    if revocation.present?

      (revocation >= p.start && revocation <= p.finish)

    else

      false

    end
  end

  def self.suspended_on_this_payroll(p)
    where('suspension >= ? and suspension <= ?', p.start, p.finish)
  end

  def suspended_on_this_payroll?(p)
    if suspension.present?

      (suspension >= p.start && suspension <= p.finish)

    else

      false

    end
  end

  def confirmed?
    confirmed
  end

  def pending?
    !confirmed
  end

  def self.renewed_on_this_payroll(p)
    where('renewal >= ? and renewal <= ?', p.start, p.finish)
  end

  def renewed_on_this_payroll?(p)
    if renewed.present?

      (renewal >= p.start && renewal <= p.finish)

    else

      false

    end
  end

  # Already processed (mostly used for registrations)
  def self.cancellation_processed
    where(revoked: true).where('revocation <= ?', Accreditation.latest_completed_payroll_finish_date)
  end

  # Cancellations to be processed (may be confirmed or not)
  def self.cancellation_not_processed
    where(revoked: true).where('revocation > ?', Accreditation.latest_completed_payroll_finish_date)
  end

  # i.e. Already processed on a previous payroll
  def cancellation_processed?
    revoked? && revocation <= Accreditation.latest_completed_payroll_finish_date
  end

  # i.e. Already processed on a previous payroll
  def cancellation_not_processed?
    revoked? && revocation > Accreditation.latest_completed_payroll_finish_date
  end

  def registration_closed_from
    years_completed = registration.schoolyear.programyear - 1

    #    self.school_term.start.next_month.next_month # i.e. May 1st

    school_term.start.next_month.next_month + years_completed.years # i.e. May 1st
    end

  def is_original?
    original == true
  end

  private

  # hotfix
  def check_start_date
    errors.add(:start, :may_not_be_prior_to_april_first) if start && start < '2017-4-1'.to_date
     end
end

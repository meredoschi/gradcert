# Related to a specific payroll
class Bankpayment < ActiveRecord::Base
  include Pretty

  include Brazilianbanking

  before_save :clear_totalamount_when_needed # on the model

  # ------------------- References ------------------------

  has_many :statement

  has_many :feedback

  belongs_to :payroll

  # Tested validations

  validates :comment, length: { maximum: 20 }
  validates_numericality_of :sequential, only_integer: true
  validates :sequential, presence: true
  validates_numericality_of :sequential, greater_than: 0
  validates_uniqueness_of :sequential

  # To do:

  # validate :payroll_may_not_be_pending # i.e. without pending, unconfirmed events

  #  validates_inclusion_of :sequential, in: 1..Bankpayment.highestseq

  #  has_many  :supervisor, :foreign_key => 'contact_id'

  # -------------------------------------------------------

  #  validates_uniqueness_of :payroll_id, unless: :resend?

  monetize :totalamount_cents

  # New for 2017

  scope :resend, -> { where(resend: true) }

  scope :done, -> { where(done: true) }

  scope :not_done, -> { where(done: false) }

  # *****************************************
  # ***** Tested code (Rspec) July 2017 *****

  # To do: reactivate this validation
  #  validate :sequential_not_too_high

  # Returns 0 when nul
  #
  # At present only PAP is being used so highest overall sequential be correct (always)

  def self.lowestseq
    @bankpayment_lowest_sequential = if sequentials != 0

                                       sequentials.min

                                     else

                                       0

                                     end

    @bankpayment_lowest_sequential
  end

  def self.highestseq
    @bankpayment_highest_sequential = if sequentials != 0

                                        sequentials.min

                                      else

                                        0

                                      end

    @bankpayment_highest_sequential
  end

  def prepared?
    prepared == true
  end

  def unprepared?
    prepared == false
  end

  # Returns 0 when nul
  def self.sequentials
    if Bankpayment.exists?

      pluck(:sequential).sort

    else

      0

    end
  end

  def sector
    payroll.sector
  end

  def fname
    organization = Settings.abbreviations.organization

    organization + '_' + sector.capitalize + '_'
  end

  def name
    payroll.shortname
  end

  def effectivedate
    payroll.paymentdate
  end

  def special_payroll?
    payroll.special?
  end

  def timestamp
    i18n_date = I18n.l(effectivedate, format: :underscore).downcase
    i18n_abbrev = I18n.t('abbreviations.payment')

    Pretty.right_now + '_' + i18n_abbrev + '_' + i18n_date + '.txt'
  end

  def bankfilename
    payrollprefix + fname + timestamp
  end

  def payrollprefix
    payroll.prefix
  end

  def monthworked
    payroll.monthworked
  end

  def payrollinfo
    effective_date_i18n = I18n.l(effectivedate, format: :compact)
    payroll_i18n = I18n.t('activerecord.models.payroll').capitalize
    month_worked_i18n = I18n.l(monthworked, format: :my).capitalize

    effective_date_i18n + ' (' + payroll_i18n + ': ' + month_worked_i18n + ')'
  end

  def pending_payroll?
    payroll.pending?
  end

  # *****                 *****
  # ***** Tested code end *****

  def self.ordered_by_most_recent_payroll
    joins(:payroll).order('payrolls.dayfinished desc')
  end

  def self.bankpayment_done
    joins(:bankpayment).merge(Bankpayment.done)
  end

  def sequential_not_too_high
    return unless sequential > Bankpayment.highestseq + 1
    errors.add(:sequential, :too_high)
  end

  def sequential_not_too_small
    return unless sequential < Bankpayment.highestseq + 1
    errors.add(:sequential, :too_small)
  end

  def payroll_may_not_be_pending
    errors.add(:payroll_id, :may_not_be_pending) if payroll.pending?
  end

  def self.by_most_recent_payroll
    joins(:payroll).merge(Payroll.ordered_by_reference_month_desc)
  end

  def self.exists_for_payroll(p)
    includes(:payroll).where(payroll: p).exists?
  end

  def self.for_payroll(p)
    includes(:payroll).where(payroll: p)
  end

  def self.for_program(prog)
    includes(:program).where(program: prog)
  end

  def self.in_sequence?
    seq = pluck(:sequential)

    1.step(seq.size).to_a == seq
  end

  # Latest
  def self.latest
    joins(:payroll).order('payrolls.monthworked DESC, sequential asc').first
  end

  # Payment sent
  def self.done
    where(done: true)
  end

  # Convenience method
  def self.latestdone
    done.latest
  end

  # Convenience method - Used for event validation
  def self.fartheststartdate
    latestdone.payroll.monthworked.next_month.next_month - 1
  end

  # Statements where generated
  def self.statements
    where(statements: true)
  end

  # Statements created?
  def without_statements?
    !statements
  end

  # Statements created?
  def statements?
    statements
  end

  # Payment completed
  def done?
    done
  end

  # Regular payment
  def regular?
    !resend
  end

  # Resend payment
  def resend?
    resend
  end

  private

  #  def yes_no(boolean)
  #    boolean ? I18n.t('yes').capitalize : I18n.t('no').capitalize
  #  end

  def clear_totalamount_when_needed # when recalculating
    totalamount = 0 if prepared?
  end
end

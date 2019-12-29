# frozen_string_literal: true

# Holds scholarship information
class Scholarship < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  has_many :payroll, foreign_key: 'scholarship_id', dependent: :restrict_with_exception,
                     inverse_of: :scholarship

  scope :pap, -> { where(pap: true) }
  scope :medres, -> { where(medres: true) }

  #  scope :pap, -> { where(pap: true, medres: false) }
  # https://stackoverflow.com/questions/29701265/how-to-build-scope-to-order-title
  scope :ordered_by_oldest_start_date, -> { reorder(start: :desc) }
  scope :ordered_by_newest_start_date, -> { reorder(start: :asc) }
  scope :ordered_by_newest, -> { reorder(start: :asc) }

  def self.default_scope
    # this notation prevents ambiguity
    order(start: :desc)
    # http://stackoverflow.com/questions/16896937/
    #      rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous
  end

  # **********************************************************************************************

  # http://stackoverflow.com/questions/1019939/ruby-on-rails-best-method-of-handling-currency-money

  monetize :amount_cents
  monetize :partialamount_cents

  # **********************************************************************************************

  validates :pap, inclusion: { in: [true], unless: :medres? }

  validates :medres, inclusion: { in: [true], unless: :pap? }

  validates :medres, inclusion: { in: [false], if: :pap? }

  validates :pap, inclusion: { in: [false], if: :medres? }

  validates :name, presence: true, length: { maximum: 100 }

  validates :amount_cents, presence: true, numericality: { greater_than: 0 }

  validates :partialamount, presence: true, if: :medres?

  validates :start, presence: true
  validates :finish, presence: true

  validate :start_finish_consistency

  #   validates :daystarted, :dayfinished, :overlap => {:scope => "pap"}

  # TDD
  def start_finish_consistency
    errors.add(:start, :must_be_consistent) unless consistent_start_finish?
  end

  # TDD
  def consistent_start_finish?
    @consistency = if start.present? && finish.present? && start < finish

                     true

                   else

                     false

                   end

    @consistency
  end

  def contextual_today?
    today = Time.zone.today
    (start <= today) && (finish >= today)
  end

  # Alias - for convenience
  def active?
    contextual_today?
  end

  # Possible to do: define contextual on arbitrary date (TDD)

  # TDD
  # Textual representation, for convenience
  def effectivedates
    I18n.t('activerecord.attributes.scholarship.virtual.effectiveperiod').capitalize \
    + ':' + I18n.l(start, format: :dmy) + ' -> ' \
    + I18n.l(finish, format: :dmy) # textual representation
  end

  # specified_dt generally will be a payroll's start date (monthworked attribute)
  def self.in_effect_on(specified_dt)
    where('start <= ? and finish >= ?', specified_dt, specified_dt)
  end

  # Scholarship information for a specific payroll
  def self.in_effect_for(payroll)
    in_effect_on(payroll.monthworked)
  end

  # Effective period
  # TDD
  def effectiveperiod
    start..finish # defined as a range
  end

  # Alias, for clarity (refactored version)
  def self.contextual_on(specified_dt)
    in_effect_on(specified_dt)
  end

  # TDD
  # Alias, for clarity
  def self.contextual_today
    in_effect_on(Time.zone.today)
  end

  # Another alias
  def self.active
    contextual_today
  end

  # TDD
  def partialamount?
    @has_partial_amount = partialamount.positive?

    @has_partial_amount
  end

  def detailed
    scholarship_amount = number_to_currency(amount)

    detailed_info = name + ' - ' + sector + ' - ' + ta('scholarship.amount') + \
                    ' ' + scholarship_amount + ' - '

    if partialamount?

      detailed_info += ta('scholarship.partialamount') + ' ' \
       + number_to_currency(partialamount) + ' - '

    end

    detailed_info + effectivedates
  end

  def sector
    if pap? then I18n.t('activerecord.attributes.scholarship.pap')
    elsif medres? then I18n.t('activerecord.attributes.scholarship.medres')
    end
  end

  # TDD
  def kind
    if pap?
      I18n.t('activerecord.attributes.scholarship.pap')
    elsif medres?
      I18n.t('activerecord.attributes.scholarship.medres')
    end
  end

  def details
    amount.symbol + ' ' + amount.to_s + ' (' + name + ')'
  end

  def pap?
    pap
  end

  def medres?
    medres
  end
end

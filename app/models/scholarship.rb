class Scholarship < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  has_many :payroll, foreign_key: 'scholarship_id'

  scope :pap, -> { where(pap: true) }
  scope :medres, -> { where(medres: true) }

  #	scope :pap, -> { where(pap: true, medres: false) }

  def self.default_scope
    # this notation prevents ambiguity
    order(start: :desc)
    # http://stackoverflow.com/questions/16896937/rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous
  end

  # ***********************************************************************************************************************************

  # http://stackoverflow.com/questions/1019939/ruby-on-rails-best-method-of-handling-currency-money

  monetize :amount_cents
  monetize :partialamount_cents

  # ***********************************************************************************************************************************

  validates_inclusion_of [:pap], in: [true], unless: :medres?

  validates_inclusion_of [:medres], in: [true], unless: :pap?

  validates_inclusion_of [:medres], in: [false], if: :pap?

  validates_inclusion_of [:pap], in: [false], if: :medres?

  validates :name, presence: true, length: { maximum: 100 }

  validates :amount_cents, presence: true, numericality: { greater_than: 0 }

  validates :partialamount, presence: true, if: :medres?

  validates :start, presence: true
  validates :finish, presence: true

  validate :start_finish_consistency

  # 	validates :daystarted, :dayfinished, :overlap => {:scope => "pap"}

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

  def self.ordered_by_oldest_start_date
    order(start: :desc)
  end

  def self.ordered_by_newest_start_date
    order(start: :asc)
  end

  # Alias, for convenience
  def self.ordered_by_newest
    ordered_by_newest_start_date
  end

  def contextual_today?
    today = Date.today
    todays_range = today..today

    effectiveperiod.overlaps? todays_range
  end

  # Alias - for convenience
  def active?
    contextual_today?
  end

  # Possible to do: define contextual on arbitrary date (TDD)

  # TDD
  # Textual representation, for convenience
  def effectivedates
    effective_dates = I18n.t('activerecord.attributes.scholarship.virtual.effectiveperiod').capitalize + ':'

    effective_dates += I18n.l(start, format: :dmy) + ' -> ' # textual representation

    #		effective_dates+=I18n.t('until')+' '

    effective_dates += I18n.l(finish, format: :dmy) # textual representation

    effective_dates
  end

  # In effect for a payroll period
  def self.for_payroll(p)
    # self.first

    where('daystarted <= ? and dayfinished >= ?', p.daystarted, p.dayfinished)
  end

  # Similar concept, more general based on reference month - works for special payrolls
  def self.on_month(m)
    dstart = (m - Settings.dayone).to_i # Converts date to integers

    where('daystarted <= ? and dayfinished >= ?', dstart, dstart)
  end

  # Effective period
  # TDD
  def effectiveperiod
    start..finish # defined as a range
  end

  # TDD
  # Active means "contextual today"
  def self.contextual_today
    today = Date.today
    todays_range = today..today

    contextual_ids = []

    scholarships = Scholarship.ordered_by_newest

    scholarships.each do |s|
      next unless s.active?

      contextual_ids << s.id
    end

    active_scholarships = scholarships.where(id: contextual_ids)

    active_scholarships
  end

  # Alias - for convenience
  def self.active
    contextual_today
  end

  # TDD
  def partialamount?
    @has_partial_amount = if partialamount > 0

                            true

                          else

                            false

                          end

    @has_partial_amount
  end

  def detailed
    scholarship_amount = number_to_currency(amount)

    detailed_info = name + ' - ' + sector + ' - ' + I18n.t('activerecord.attributes.scholarship.amount') + ' ' + scholarship_amount + ' - '

    if partialamount?

      detailed_info += I18n.t('activerecord.attributes.scholarship.partialamount') + ' ' + number_to_currency(partialamount) + ' - '

    end

    detailed_info += effectivedates
  end

  def sector
    scholarship_sector = if pap? then I18n.t('activerecord.attributes.scholarship.pap')
                         elsif medres? then I18n.t('activerecord.attributes.scholarship.medres')

  end

    scholarship_sector
end

  # TDD
  def kind
    scholarship_kind = if pap? then I18n.t('activerecord.attributes.scholarship.pap')
                       elsif medres? then I18n.t('activerecord.attributes.scholarship.medres')

  end

    scholarship_kind
  end

  def details
    amount.symbol + ' ' + amount.to_s + ' (' + name + ')'
  end

  # Takes a date object
  def self.for_reference_month
    where(Date.today.to_i > :finish)
  end

  # Takes a date object
  def self.for_reference_month
    where(Date.today.to_i > :finish)
  end

  def self.pap
    where(pap: true)
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
end

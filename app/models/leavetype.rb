# Provides for the various leavetypes, both paid and unpaid
class Leavetype < ActiveRecord::Base
  has_many :leave, foreign_key: 'leavetype_id'

  has_many  :event, foreign_key: 'leavetype_id'

  # -------------------------------------------------------

  # RSPEC

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates :name, length: { maximum: 100 }

  validates :comment, length: { maximum: 200 }

  validate :days_paid_cap_consistency

  def breadth
    sep = ' | '

    setnumdays_i18n + sep + dayspaidcap_i18n + sep + maxnumdays_i18n
  end

  def setnumdays_i18n
    @leavetype_setnumdays_txt = ''

    if setnumdays.present? && setnumdays > 0
      attrib = 'activerecord.attributes.leavetype.setnumdays'
      @leavetype_setnumdays_txt = I18n.t(attrib) + ': ' + setnumdays.to_s
    end

    @leavetype_setnumdays_txt
  end

  def maxnumdays_i18n
    @leavetype_maxnumdays_i18n = ''

    if maxnumdays.present? && maxnumdays > 0
      attrib = 'activerecord.attributes.leavetype.maxnumdays'
      @leavetype_maxnumdays_i18n = I18n.t(attrib) + ': ' + maxnumdays.to_s
    end

    @leavetype_maxnumdays_i18n
  end

  def dayspaidcap_i18n
    @leavetype_dayspaidcap_i18n = ''

    if dayspaidcap.present? && dayspaidcap > 0
      attrib = 'activerecord.attributes.leavetype.dayspaidcap'
      @leavetype_dayspaidcap_i18n = I18n.t(attrib) + ': ' + dayspaidcap.to_s
    end

    @leavetype_dayspaidcap_i18n
  end

  # ----

  def days_paid_cap_consistent_with_max_num_days?
    dayspaidcap.present? && maxnumdays.present? && (maxnumdays >= dayspaidcap)
  end

  #  validate :days_taken_within_paid_limit

  #  validate :vacations_are_paid

  #

  def vacations_are_paid
    return unless vacation.present? && paid == false
    errors.add(:paid, :must_be_true_for_vacation)
  end

  def days_paid_cap_consistency
    return unless days_paid_cap_consistent_with_max_num_days?
    errors.add(:dayspaidcap, :days_paid_cap_not_exceed_max_num_days)
  end

  # Paid, remunerated leave
  def self.paid
    where(paid: true)
  end

  # Unpaid (e.g. personal leave)
  def self.unpaid
    where(paid: false)
  end

  def self.limited
    where('dayswithpaylimit > 0')
  end

  def limited?
    if dayspaidcap.present?

      true

    else

      false

    end
  end

  def self.default_scope
    # this notation prevents ambiguity
    order(name: :asc)
    # http://stackoverflow.com/questions/16896937/rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous
  end
  #
  #    validates_inclusion_of [:pap], in: [true], unless: :medres?
  #
  #    validates_inclusion_of [:medres], in: [true], unless: :pap?
  #
  #   validates_inclusion_of [:medres], in: [false], if: :pap?
  #
  #   validates_inclusion_of [:pap], in: [false], if: :medres?
  #

  # Some types of leave have set number of days established by law

  def rigid?
    if days.present? && days > 0
      true
    else
      false
    end
  end

  # Vacation
  def vacation?
    vacation
  end

  def flexible?
    !rigid?
  end

  def self.vacation
    where(vacation: true)
  end

  def self.flexible
    # http://stackoverflow.com/questions/25086952/rails-how-do-i-exclude-records-with-entries-in-a-join-table
    where.not(id: rigid)
  end

  def self.rigid
    where('days>0')
  end

  def self.pap
    where(pap: true)
  end

  def self.medres
    where(medres: true)
  end

  def paid?
    paid
  end

  def unpaid?
    !paid
  end

  def pap?
    pap
  end

  def medres?
    medres
  end
end

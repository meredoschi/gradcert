# frozen_string_literal: true

# Brazilian bank branches
class Bankbranch < ActiveRecord::Base
  # ------------------- References ------------------------

  # belongs_to :user

  has_one :address, foreign_key: 'bankbranch_id'
  accepts_nested_attributes_for :address

  has_one :phone, foreign_key: 'bankbranch_id'
  accepts_nested_attributes_for :phone

  has_many :bankaccount, foreign_key: 'bankbranch_id'

  # Validations
  # TDD Review
  # Marcelo - June 2017

  %i[name code verificationdigit].each do |required_field|
    validates required_field, presence: true
  end

  validates :name, length: { maximum: 200 }

  #  validates :code, uniqueness: true, case_sensitive: false
  validates :code, uniqueness: true

  validates :code, numericality: { only_integer: true }
  validates :code, numericality: { greater_than_or_equal_to: 0 }
  validates :code, numericality: { less_than_or_equal_to: Settings.max_number_bankbranches }
  validates :code, length: { in: 1..Settings.max_length_for_bankbranch_code }

  validates :verificationdigit, length: { is: 1 }

  validate :verification_digit_is_consistent

  # https://github.com/adzap/validates_timeliness
  validates_date :opened, on_or_before: :today

  def verification_digit_is_consistent
    errors.add(:verificationdigit, :inconsistent) unless with_valid_vd?
  end

  def details
    code.to_s + '-' + verificationdigit.to_s + ' [' + name + '] '
  end

  def with_valid_vd?
    @status = verificationdigit == Brazilianbanking.branch_verification_digit(code).to_s

    @status
  end

  def future_opening_date?
    @status = opened > Date.today

    @status
  end

  def valid_dv
    with_valid_vd?
  end

  def full
    code.to_s + '-' + verificationdigit.to_s
  end

  def state
    address.municipality.stateregion.state.abbreviation
  end

  def location
    municipality_name + ' - ' + state
  end

  def municipality
    address.municipality
  end

  def municipality_name
    address.municipality.name
  end

  # -------------------------------------------------------

  def self.default_scope
    # this notation prevents ambiguity
    #     order(name: :asc)
    #      order(code: :asc)
    order(numericalcode: :asc)

    # http://stackoverflow.com/questions/16896937/rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous
  end

  # *************************************************************************************
end

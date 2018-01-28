class Bankaccount < ActiveRecord::Base
  has_paper_trail

  belongs_to :student

  belongs_to :bankbranch

  MAX_LEN = Settings.max_length_for_bankaccount_number
  MAX_NUM = Settings.max_number_bankaccounts

  %i[num verificationdigit bankbranch_id].each do |required_field|
    validates required_field, presence: true
  end

  validates_uniqueness_of :num, scope: [:bankbranch_id]
  validates :num, length: { in: 1..MAX_LEN }
  validates :num, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: MAX_NUM }

  validates :verificationdigit, length: { is: 1 }

  validate :verification_digit_is_appropriate

  def verification_digit_is_appropriate
    errors.add(:verificationdigit, :inconsistent) unless consistent_verification_digit?
  end

  #

  # --- TDD start ---

  def details
    num.to_s + '-' + verificationdigit.to_s
  end

  def consistent_verification_digit?
    @consistency = true

    if verificationdigit && verificationdigit.casecmp('X').zero?

      # Compare strings
      if verificationdigit.to_s != Brazilianbanking.account_verification_digit(num).to_s
        @consistency = false
      end

    else

      # Compare integers
      if verificationdigit.to_i != Brazilianbanking.account_verification_digit(num).to_i || verificationdigit.nil?
        @consistency = false
      end

    end

    @consistency
  end

  # --- TDD finish ---

  #
  def full
    num + '-' + verificationdigit
  end
end

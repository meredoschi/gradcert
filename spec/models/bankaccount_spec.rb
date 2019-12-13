# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bankaccount, type: :model do
  #  Bankaccount(id: integer, student_id: integer, bankbranch_id: integer, num: string,
  #  verificationdigit: string)
  let(:bankaccount) { FactoryBot.create(:bankaccount) }
  MAX_LEN = Settings.max_length_for_bankaccount_number
  MAX_NUM = Settings.max_number_bankaccounts

  it { is_expected.to validate_presence_of(:num) }
  it { is_expected.to validate_length_of(:num).is_at_most(MAX_LEN) }
  it { is_expected.to validate_numericality_of(:num).only_integer }
  it { is_expected.to validate_numericality_of(:num).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_numericality_of(:num).is_less_than_or_equal_to(MAX_NUM) }
  it { is_expected.to validate_uniqueness_of(:num).scoped_to(:bankbranch_id).case_insensitive }

  it { is_expected.to validate_presence_of(:bankbranch_id) }

  #
  #   validates :verificationdigit, presence: true,  length:  { is: 1 }
  #
  #   validates_uniqueness_of :num, :scope => [:bankbranch_id]
  #
  #   branch_verification_digit
  #   account_verification_digit
  #

  it 'can be created' do
    print I18n.t('activerecord.models.bankaccount').capitalize + ': '
    #    bankaccount = FactoryBot.create(:bankaccount)
    #    puts bankaccount.code.to_s
    puts bankaccount.details
  end

  it '-details' do
    bankaccount_details = bankaccount.num.to_s + '-' + bankaccount.verificationdigit.to_s
    expect(bankaccount.details).to eq(bankaccount_details)
  end

  it '-consistent_verification_digit?' do
    vd = bankaccount.verificationdigit
    @consistency = true

    if
vd&.casecmp('X')&.zero?

      # Compare strings
      if vd.to_s != Brazilianbanking.account_verification_digit(bankaccount.num).to_s
        @consistency = false
      end

    else

      # Compare integers
      if vd.to_i != Brazilianbanking.account_verification_digit(bankaccount.num).to_i || vd.nil?
        @consistency = false
      end

    end

    @consistency

    expect(bankaccount.consistent_verification_digit?).to eq(@consistency)
  end

  it '-consistent_verification_digit? returns false with invalid vd' do
    print 'Correct VD: '
    puts bankaccount.verificationdigit.to_s

    vd = bankaccount.verificationdigit

    if vd == 'X'
      bankaccount.verificationdigit = 1
    else
      if vd == '9'
        bankaccount.verificationdigit = 0

      else # At most 8
        bankaccount.verificationdigit += 1
      end

    end

    print 'Invalid account num: '
    puts bankaccount.details
    expect(bankaccount.consistent_verification_digit?).to eq false
  end

  it '-consistent_verification_digit? returns true with valid vd' do
    expect(bankaccount.consistent_verification_digit?).to eq true
  end

  it 'creation is blocked if verification digit is inconsistent' do
    print I18n.t('activerecord.models.bankaccount').capitalize + ': '

    expect do
      bankaccount = FactoryBot.create(:bankaccount,
                                      :incorrect_vd)
    end .to raise_error(ActiveRecord::RecordInvalid)
  end
end

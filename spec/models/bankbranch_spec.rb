# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bankbranch, type: :model do
  let(:bankbranch) { FactoryBot.create(:bankbranch) }

  # https://github.com/thoughtbot/shoulda-matchers
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_most(200) }

  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_uniqueness_of(:code).case_insensitive }
  it { is_expected.to validate_numericality_of(:code).only_integer }
  it { is_expected.to validate_numericality_of(:code).is_greater_than_or_equal_to(0) }
  it {
    is_expected.to validate_numericality_of(:code).is_less_than_or_equal_to(Settings
    .max_number_bankbranches)
  }

  #   validates :code, length: { in: 1..}

  it { is_expected.to validate_presence_of(:verificationdigit) }
  it { is_expected.to validate_length_of(:verificationdigit).is_equal_to(1) }

  it {
    is_expected.to validate_length_of(:code).is_at_least(1).is_at_most(Settings
    .max_length_for_bankbranch_code)
  }

  it 'can be created' do
    print I18n.t('activerecord.models.bankbranch').capitalize + ': '
    bankbranch = FactoryBot.create(:bankbranch)
    #    puts bankbranch.code.to_s
    puts bankbranch.details
  end

  it '-details' do
    #    bankbranch = FactoryBot.create(:bankbranch)
    bankbranch_details = bankbranch.code.to_s + '-' + bankbranch.verificationdigit.to_s + \
                         ' [' + bankbranch.name + '] '
    expect(bankbranch.details).to eq(bankbranch_details)
  end

  it '-with_valid_dv?' do
    @status = bankbranch.verificationdigit == Brazilianbanking
              .calculate_verification_digit(bankbranch.code, 4).to_s

    @status
  end

  it '-future_opening_date?' do
    #    if bankbranch.opened.present? && bankbranch.opened > Date.today

    @status = bankbranch.opened > Date.today

    @status
  end

  it 'with_valid_vd? is false for inconsistent verification digit' do
    bankbranch.code = 9876
    bankbranch.verificationdigit = 5

    expect(bankbranch.with_valid_vd?).to be false
    puts bankbranch.details
  end

  # deprecated
  it '-valid_dv is an alias' do
    expect(bankbranch.valid_dv).to eq(bankbranch.with_valid_vd?)
  end

  it 'creation is blocked if verification digit is inconsistent' do
    print I18n.t('activerecord.models.bankbranch').capitalize + ': '
    expect do
      bankbranch = FactoryBot.create(:bankbranch,
                                     :incorrect_vd)
    end    .to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'creation is blocked if opening date is in the future' do
    print I18n.t('activerecord.models.bankbranch').capitalize + ': '
    expect do
      bankbranch = FactoryBot.create(:bankbranch,
                                     :opens_in_a_month)
    end    .to raise_error(ActiveRecord::RecordInvalid)
  end

  it '-full' do
    bankbranch_full = bankbranch.code.to_s + '-' + bankbranch.verificationdigit.to_s
    expect(bankbranch.full).to eq(bankbranch_full)
  end

  it '-state' do
    bankbranch_state = bankbranch.address.municipality.stateregion.state.abbreviation
    expect(bankbranch.state).to eq(bankbranch_state)
  end

  it '-location' do
    bankbranch_location = bankbranch.municipality_name + ' - ' + bankbranch.state
    expect(bankbranch.location).to eq(bankbranch_location)
  end

  # Abbreviated name
  it '-municipality_name' do
    bankbranch_municipality = bankbranch.address.municipality.name
    expect(bankbranch.municipality_name).to eq(bankbranch_municipality)
  end

  # intermediate tests (to help set up factories)
  it '-address' do
    bankbranch_address = bankbranch.address
    puts bankbranch_address.id.to_s
    expect(bankbranch.address).to eq(bankbranch_address)
  end

  it '-municipality' do
    bankbranch_municipality = bankbranch.address.municipality
    expect(bankbranch.municipality).to eq(bankbranch_municipality)
  end
end

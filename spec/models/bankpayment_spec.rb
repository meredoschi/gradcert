require 'rails_helper'

RSpec.describe Bankpayment, type: :model do
  let(:bankpayment) { FactoryBot.create(:bankpayment) }

  it { is_expected.to validate_length_of(:comment).is_at_most(20) }
  it { is_expected.to validate_numericality_of(:sequential).only_integer }
  it { is_expected.to validate_presence_of(:sequential) }
  it { is_expected.to validate_numericality_of(:sequential).is_greater_than(0) }
  it { is_expected.to validate_uniqueness_of(:sequential) }

  it 'can be created' do
    #    created by let
    #    bankpayment = FactoryBot.create(:bankpayment)
  end

  it '-prepared?' do
    bankpayment_preparation = bankpayment.prepared?

    expect(bankpayment_preparation).to eq(bankpayment.prepared?)
  end

  it '-prepared? is false for default factory' do
    expect(bankpayment.prepared?).to be false
  end

  it '-unprepared? is true for default factory' do
    expect(bankpayment.unprepared?).to be true
  end

  it '-unprepared?' do
    bankpayment_preparation = bankpayment.unprepared?

    expect(bankpayment_preparation).to eq(bankpayment.unprepared?)
  end

  it 'monthworked' do
    bankpayment_monthworked = bankpayment.payroll.monthworked

    expect(bankpayment_monthworked).to eq(bankpayment.monthworked)
  end

  it '-payrollinfo' do
    effective_date_i18n = I18n.l(bankpayment.effectivedate, format: :compact)
    payroll_i18n = I18n.t('activerecord.models.payroll').capitalize
    month_worked_i18n = I18n.l(bankpayment.monthworked, format: :my).capitalize

    effective_date_i18n + ' (' + payroll_i18n + ': ' + month_worked_i18n + ')'
  end

  it '-name' do
    bankpayment_name = bankpayment.payroll.shortname

    expect(bankpayment_name).to eq(bankpayment.name)
  end

  it '-special_payroll?' do
    bankpayment = FactoryBot.create(:bankpayment, :special)
    payroll_special_situation = bankpayment.payroll.special?

    expect(payroll_special_situation).to eq(bankpayment.special_payroll?)
  end

  it '-sector' do
    bankpayment_sector = bankpayment.payroll.sector

    expect(bankpayment_sector).to eq(bankpayment.sector)
  end

  it '-fname' do
    organization = Settings.abbreviations.organization

    bankpayment_fname = organization + '_' + bankpayment.sector.capitalize + '_'

    expect(bankpayment_fname).to eq(bankpayment.fname)
  end

  it '-bankfilename' do
    localized_date = I18n.l(bankpayment.effectivedate, format: :underscore).downcase
    localized_abbreviation = I18n.t('abbreviations.payment')

    timestamp = Pretty.right_now + '_' + localized_abbreviation + '_' + localized_date + '.txt'

    bankpayment_file_name = bankpayment.payroll.prefix + bankpayment.fname + timestamp

    expect(bankpayment_file_name).to eq bankpayment.bankfilename
  end

  it '-payrollprefix' do
    bankpayment_payroll_prefix = bankpayment.payroll.prefix

    expect(bankpayment_payroll_prefix).to eq bankpayment.payrollprefix
  end

  it '-timestamp' do
    i18n_date = I18n.l(bankpayment.effectivedate, format: :underscore).downcase
    i18n_abbrev = I18n.t('abbreviations.payment')

    bankpayment_timestamp = Pretty.right_now + '_' + i18n_abbrev + '_' + i18n_date + '.txt'

    expect(bankpayment_timestamp).to eq(bankpayment.timestamp)
  end

  it 'effectivedate' do
    bankpayment_effective_date = bankpayment.effectivedate

    expect(bankpayment_effective_date).to eq(bankpayment.effectivedate)
  end

  it 'pending_payroll?' do
    bankpayment = FactoryBot.create(:bankpayment)
    bankpayment_pending_status = bankpayment.pending_payroll?

    expect(bankpayment_pending_status).to eq(bankpayment.pending_payroll?)
  end

  it 'pending_payroll?' do
    bankpayment = FactoryBot.create(:bankpayment)
    bankpayment_pending_status = bankpayment.pending_payroll?

    expect(bankpayment_pending_status).to eq(bankpayment.pending_payroll?)
  end
end

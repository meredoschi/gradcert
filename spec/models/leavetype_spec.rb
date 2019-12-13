# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Leavetype, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  it { is_expected.to validate_length_of(:name).is_at_most(100) }
  it { is_expected.to validate_length_of(:comment).is_at_most(200) }

  let(:leavetype) { FactoryBot.create(:leavetype) }

  pending '-days_paid_cap_consistent_with_max_num_days?' do
    leavetype = FactoryBot.create(:leavetype, :honeymoon, :days_paid_cap_consistent)

    attributes_present = leavetype.dayspaidcap.present? && leavetype.maxnumdays.present?

    situation = attributes_present && (leavetype.maxnumdays > leavetype.dayspaidcap)

    expect(leavetype.days_paid_cap_consistent_with_max_num_days?).to eq(situation)
  end

  pending 'breadth' do
    leavetype = FactoryBot.create(:leavetype, :honeymoon, :days_paid_cap_consistent)

    sep = ' | '

    @leavetype_breadth = ''

    @leavetype_breadth += leavetype.setnumdays_i18n + sep if leavetype.setnumdays > 0

    @leavetype_breadth += leavetype.dayspaidcap_i18n + sep if leavetype.dayspaidcap > 0

    @leavetype_breadth += leavetype.maxnumdays_i18n if leavetype.maxnumdays > 0

    expect(leavetype_breadth).to eq(leavetype.breadth)
  end

  pending '-days_paid_cap_consistent_with_max_num_days? is true with correct data' do
    leavetype = FactoryBot.create(:leavetype, :honeymoon, :days_paid_cap_consistent)

    expect(leavetype.days_paid_cap_consistent_with_max_num_days?).to be true
  end

  it '-days_paid_cap_consistent_with_max_num_days? is false with incorrect data' do
    leavetype = FactoryBot.create(:leavetype, :honeymoon, :days_paid_cap_inconsistent)

    expect(leavetype.days_paid_cap_consistent_with_max_num_days?).to be false
  end

  it '-setnumdays_i18n' do
    @leavetype_setnumdays_i18n = ''

    if leavetype.setnumdays.present? && leavetype.setnumdays > 0
      @leavetype_setnumdays_i18n = I18n.t('activerecord.attributes.leavetype.setnumdays')
      @leavetype_setnumdays_i18n += ': ' + leavetype.setnumdays.to_s
    end

    expect(@leavetype_setnumdays_i18n).to eq(leavetype.setnumdays_i18n)
  end

  it '-dayspaidcap_i18n' do
    @leavetype_dayspaidcap_i18n = ''

    if leavetype.dayspaidcap.present? && leavetype.dayspaidcap > 0
      @leavetype_dayspaidcap_i18n = I18n.t('activerecord.attributes.leavetype.dayspaidcap')
      @leavetype_dayspaidcap_i18n += ': ' + leavetype.dayspaidcap.to_s
    end

    expect(@leavetype_dayspaidcap_i18n).to eq(leavetype.dayspaidcap_i18n)
  end

  it '-maxnumdays_i18n' do
    @leavetype_maxnumdays_i18n = ''

    if leavetype.maxnumdays.present? && leavetype.maxnumdays > 0
      @leavetype_maxnumdays_i18n = I18n.t('activerecord.attributes.leavetype.maxnumdays')
      @leavetype_maxnumdays_i18n += ': ' + leavetype.maxnumdays.to_s
    end

    expect(@leavetype_maxnumdays_i18n).to eq(leavetype.maxnumdays_i18n)
  end

  it 'creation is blocked when !days_paid_cap_consistent_with_max_num_days?' do
    expect do
      FactoryBot.create(:leavetype, :honeymoon,
                        :days_paid_cap_consistent)
    end.to raise_error(ActiveRecord::RecordInvalid)
  end

  #  it 'can be created' do
  #    leavetype=FactoryBot.create(:leavetype)
  #    puts leavetype.name
  #  end

  it 'PAP can be created' do
    leavetype = FactoryBot.create(:leavetype, :pap)

    puts leavetype.name
  end
end

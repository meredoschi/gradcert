# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Personalinfo, type: :model do
  let(:personalinfo) do
    FactoryBot.create(:personalinfo, :with_mothers_name_and_ssn)
  end

  let(:sexes) do
    [I18n.t('activerecord.constants.personalinfo.personal_characteristic.female'),
     I18n.t('activerecord.constants.personalinfo.personal_characteristic.male'),
     I18n.t('activerecord.constants.personalinfo.personal_characteristic.unspecified')]
  end

  let(:genders) { sexes }

  let(:idtypes) do
    [I18n.t('activerecord.constants.personalinfo.idtype.state_registration'),
     I18n.t('activerecord.constants.personalinfo.idtype.registered_foreigner'),
     I18n.t('activerecord.constants.personalinfo.idtype.passport')]
  end

  it {
    expect(Personalinfo::GENDERS).to eq(genders)
  }

  context 'Associations' do
    pending { is_expected.to belong_to(:municipality) } # Where person was born
    it { is_expected.to belong_to(:state) } # State which issued id
    it { is_expected.to belong_to(:country) } # Nationality (foreigners)
    it { is_expected.to belong_to(:contact) }
  end

  it 'can be created' do
    FactoryBot.create(:personalinfo, :with_mothers_name_and_ssn)
  end

  context 'validations' do
    it {
      expect(Personalinfo::IDTYPES).to eq(idtypes)
    }
  end

  context 'instance methods' do
    #
    # Digito verificador do NIT
    #
    it '-ssn_weighted_sum' do
      personal_info_ssn_weighted_sum = 0
      factors = [3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
      (0..9).each do |i|
        personal_info_ssn_weighted_sum += factors[i] * personalinfo.socialsecuritynumber[i].to_i
      end
      expect(personal_info_ssn_weighted_sum).to eq(personalinfo.ssn_weighted_sum)
    end

    #
    it '-nit_dv' do # Brazilian Social Security Number - Verification digit
      personalinfo_ssn_control_digit = 11 - (personalinfo.ssn_weighted_sum % 11)
      personalinfo_ssn_control_digit = if personalinfo_ssn_control_digit < 10
                                         personalinfo_ssn_control_digit.to_s
                                       else
                                         '0'
                                       end
      expect(personalinfo_ssn_control_digit).to eq(personalinfo.nit_dv)
    end
  end
end

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

    it '-birth' do
      formatted_birth_date = I18n.l(personalinfo.dob)
      expect(formatted_birth_date).to eq(personalinfo.birth)
    end
    # Brazilian Taxpayer identification number - First verification digit

    it '-cpf_dv1' do
      v = 0
      (1..9).each do |k|
        v += k * personalinfo.tin[k - 1].to_i
      end
      v = v % 11
      v = v % 10
      expect(v).to eq(personalinfo.cpf_dv1)
    end

    # Segundo digito verificador do CPF
    # Brazilian Taxpayer identification number - Second verification digit
    it '-cpf_dv2' do
      v = 0
      (1..8).each do |k|
        v += k * personalinfo.tin[k].to_i
      end
      v += 9 * personalinfo.cpf_dv1.to_i # Chama DV1
      v = v % 11
      v = v % 10
      expect(v).to eq(personalinfo.cpf_dv2)
    end

    it '-genderdiversity?' do
      unspecified = I18n.t('activerecord.constants.personalinfo.
        personal_characteristic.unspecified')
      is_diversity = (personalinfo.sex.present? && personalinfo.gender.present? &&  \
        ((personalinfo.sex != personalinfo.gender) || personalinfo.sex == unspecified  \
        || personalinfo.gender == unspecified))
      expect(is_diversity).to eq(personalinfo.genderdiversity?)
    end
  end
end

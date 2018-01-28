require 'rails_helper'

RSpec.describe Personalinfo, type: :model do
  let(:personalinfo) do
    FactoryBot.create(:personalinfo)
  end

  let(:sexes) do
    [Settings.personalcharacteristic.female,
     Settings.personalcharacteristic.male,
     Settings.personalcharacteristic.unspecified]
  end

  let(:idtypes) do
    [Settings.personaldocument.state_registration,
     Settings.personaldocument.registered_foreigner,
     Settings.personaldocument.passport]
  end

  it 'can be created' do
    FactoryBot.create(:personalinfo)
  end

  it {
    puts 'SEXES (constant)'
    expect(Personalinfo::SEXES).to eq(sexes)
  }

  it {
    puts 'GENDERS (constant)'
    expect(Personalinfo::GENDERS).to eq(sexes)
  }

  it {
    puts 'IDTYPES (constant)'
    puts 'Currently this is not i18n (refer to application_settings.yml)'
    expect(Personalinfo::IDTYPES).to eq(idtypes)
  }

  pending do
    should validate_inclusion_of(:idtype)
      .in_array(%w[open resolved unresolved])
  end

  # Digito verificador do NIT

  it '-ssn_weighted_sum' do
    personal_info_ssn_weighted_sum = 0

    factors = [3, 2, 9, 8, 7, 6, 5, 4, 3, 2]

    (0..9).each do |i|
      personal_info_ssn_weighted_sum += factors[i] * personalinfo.socialsecuritynumber[i].to_i
    end

    expect(personal_info_ssn_weighted_sum).to eq(personalinfo.ssn_weighted_sum)
  end

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

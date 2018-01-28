require 'rails_helper'

RSpec.describe Profession, type: :model do
  let(:profession) { FactoryBot.create(:profession) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  it { is_expected.to validate_length_of(:name).is_at_most(150) }

  it { is_expected.to validate_presence_of(:occupationcode) }
  it { is_expected.to validate_uniqueness_of(:occupationcode) }
  it { is_expected.to validate_numericality_of(:occupationcode).only_integer }
  it { is_expected.to validate_numericality_of(:occupationcode).is_greater_than_or_equal_to(1) }
  it {
    is_expected.to validate_numericality_of(:occupationcode)
      .is_less_than_or_equal_to(1_000_000)
  }

  it '-can be created' do
    FactoryBot.create(:profession)
  end

  it '-prefix' do
    profession_prefix = profession.occupationcode / 10_000
    expect(profession_prefix).to eq profession.prefix
  end

  # To do, revise, change to pap?
  it '-pap' do
    profession_pap = profession.pap
    expect(profession_pap).to eq profession.pap
  end

  # To do, revise, change to medres?
  it '-medres' do
    profession_medres = profession.medres
    expect(profession_medres).to eq profession.medres
  end

  #  it '-pap' do
  #    professionalfamily.pap
  #  end

  #  it '-medres' do
  #    professionalfamily.medres
  #  end
end

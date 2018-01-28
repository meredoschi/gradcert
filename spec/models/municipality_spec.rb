require 'rails_helper'

RSpec.describe Municipality, type: :model do
  let(:municipality) { FactoryBot.create(:municipality) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_most(70) }

  it 'can be created' do
    FactoryBot.create(:municipality)
  end

  it '-stateabbreviation' do
    municipality_state_abbreviation = municipality.asciinamewithstate.split(' / ')[1]
    expect(municipality_state_abbreviation).to eq(municipality.stateabbreviation)
  end

  it '-institution_count' do
    num_institutions_from_municipality = municipality.address.institution.count
    expect(num_institutions_from_municipality).to eq municipality.institution_count
  end

  # http://stackoverflow.com/questions/3784394/rails-3-combine-two-variables
  it '-name_with_state' do
    municipality_name_with_state = municipality.namewithstate
    expect(municipality_name_with_state).to eq municipality.name_with_state
  end

  it '-city is an alias to name' do
    city = municipality.name
    expect(city).to eq municipality.name
  end

  # Name without accents
  it '-nameplain' do
    municipality_plain_name = I18n.transliterate(municipality.name)

    expect(municipality_plain_name).to eq municipality.nameplain
  end
end

require 'rails_helper'

RSpec.describe Country, type: :model do
  let(:country) { FactoryBot.create(:country) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  it { is_expected.to validate_length_of(:name).is_at_most(70) }

  it { is_expected.to validate_presence_of(:brname) }
  it { is_expected.to validate_uniqueness_of(:brname).case_insensitive }
  it { is_expected.to validate_length_of(:brname).is_at_most(70) }

  it 'can be created' do
    FactoryBot.create(:country)
  end
end

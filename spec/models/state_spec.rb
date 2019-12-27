# frozen_string_literal: true

require 'rails_helper'

RSpec.describe State, type: :model do
  let(:state) { FactoryBot.create(:state) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:abbreviation) }

  it { is_expected.to validate_length_of(:name).is_at_most(80) }
  it { is_expected.to validate_length_of(:abbreviation).is_at_most(10) }

  it 'can be created' do
    FactoryBot.create(:state)
  end
end

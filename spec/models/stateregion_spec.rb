# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Stateregion, type: :model do
  let(:stateregion) { FactoryBot.create(:stateregion) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_most(50) }

  it 'can be created' do
    FactoryBot.create(:stateregion)
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Statement, type: :model do
  let(:statement) { FactoryBot.create(:statement) }

  #  it { is_expected.to validate_presence_of(:name) }
  #  it { is_expected.to validate_length_of(:name).is_at_most(50) }

  it 'can be created' do
    FactoryBot.create(:statement)
  end
end

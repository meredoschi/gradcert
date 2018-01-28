require 'rails_helper'

RSpec.describe Professionalfamily, type: :model do
  let(:professionalfamily) { FactoryBot.create(:professionalfamily) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  it { is_expected.to validate_length_of(:name).is_at_most(150) }

  it '-can be created' do
    FactoryBot.create(:professionalfamily)
  end
end

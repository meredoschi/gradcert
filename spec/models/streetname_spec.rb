# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Streetname, type: :model do
  let(:streetname) { FactoryBot.create(:streetname) }

  it '-it has a designation' do
    print I18n.t('activerecord.models.streetname').capitalize + ': '
    streetname = FactoryBot.create(:streetname)
    puts streetname.designation
  end

  it { is_expected.to validate_presence_of(:designation) }
  it { is_expected.to validate_uniqueness_of(:designation).case_insensitive }
  it { is_expected.to validate_length_of(:designation).is_at_most(50) }
end

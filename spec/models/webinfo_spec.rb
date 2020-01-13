# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Webinfo, type: :model do
  let(:webinfo) { FactoryBot.create(:webinfo) }

  context 'Associations' do
    it { is_expected.to belong_to(:contact) }
    it { is_expected.to belong_to(:council) }
    it { is_expected.to belong_to(:institution) }
    it { is_expected.to belong_to(:regionaloffice) }
  end

  context 'creation' do
    it '-can be created' do
      FactoryBot.create(:webinfo)
    end
  end

  context 'Validations' do
    it { is_expected.to validate_length_of(:email).is_at_most(100) }
    it { is_expected.to validate_length_of(:site).is_at_most(150) }

    it { is_expected.to validate_length_of(:facebook).is_at_most(40) }
    it { is_expected.to validate_length_of(:twitter).is_at_most(40) }
    it { is_expected.to validate_length_of(:other).is_at_most(40) }
  end

  it '-creation is blocked if site URI starts with http(s)://' do
    site_i18n = I18n.t('activerecord.attributes.webinfo.site')

    msg = I18n.t('validation_failed') + ': ' + site_i18n + ' ' \
      + I18n.t('activerecord.errors.models.webinfo.attributes.site.incorrect')
    expect do
      FactoryBot.create(:webinfo, :website_url_starts_with_http)
    end .to raise_error(ActiveRecord::RecordInvalid, msg)
  end
end

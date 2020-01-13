# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Phone, type: :model do
  let(:phone) { FactoryBot.create(:phone) }

  context 'associations' do
    it { is_expected.to belong_to(:bankbranch) }
    it { is_expected.to belong_to(:contact) }
    it { is_expected.to belong_to(:council) }
    it { is_expected.to belong_to(:institution) }
    it { is_expected.to belong_to(:regionaloffice) }
  end

  context 'individual' do
    # https://makandracards.com/makandra/46172-shoulda-matchers-how-to-test-conditional-validations
    before { allow(subject).to receive(:individual?).and_return(true) }

    it { is_expected.to validate_presence_of(:mobile) }
    it { is_expected.to validate_length_of(:mobile).is_at_least(8) }
    it { is_expected.to validate_length_of(:mobile).is_at_most(25) }
  end

  context 'organization (!individual)' do
    before { allow(subject).to receive(:individual?).and_return(false) }
    it { is_expected.to validate_presence_of(:main) }
    it { is_expected.to validate_length_of(:main).is_at_least(6) }
    it { is_expected.to validate_length_of(:main).is_at_most(30) }
  end

  context 'instance methods' do
    it '-bankbranch?' do
      is_bankbranch = phone.bankbranch_id.present?
      expect(is_bankbranch).to eq(phone.bankbranch?)
    end

    it '-individual?' do
      is_individual = phone.contact_id.present?
      expect(is_individual).to eq(phone.individual?)
    end

    it '-council?' do
      is_council = phone.council_id.present?
      expect(is_council).to eq(phone.council?)
    end

    it '-institution?' do
      is_institution = phone.institution_id.present?
      expect(is_institution).to eq(phone.institution?)
    end

    it '-regionaloffice?' do
      is_regionaloffice = phone.regionaloffice_id.present?
      expect(is_regionaloffice).to eq(phone.regionaloffice?)
    end
  end

  context 'creation' do
    it 'can be created' do
      FactoryBot.create(:phone)
    end
  end
end

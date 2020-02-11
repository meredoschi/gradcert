# frozen_string_literal: true

require 'rails_helper'

#  => Accreditation(id: integer, institution_id: integer, start: date,
#  renewal: date, revoked: boolean, revocation: date, comment: string,
#  suspension: date, suspended: boolean, original: boolean, renewed: boolean,
#  program_id: integer, registration_id: integer, confirmed: boolean)

RSpec.describe Accreditation, type: :model do
  let(:accreditation) { FactoryBot.create(:accreditation, :program) }

  let(:program_accreditation) { FactoryBot.create(:accreditation, :program) }

  let(:registration_accreditation) { FactoryBot.create(:accreditation, :registration) }

  let(:institution_accreditation) { FactoryBot.create(:accreditation, :institution) }

  it '-institutional?' do
    pertains_to_institution = institution_accreditation.institution_id.present?

    expect(pertains_to_institution).to eq(institution_accreditation.institutional?)
  end

  it '-program?' do
    pertains_to_program = program_accreditation.program_id.present?

    expect(pertains_to_program).to eq(program_accreditation.program?)
  end

  it '-info' do
    kind_i18n = I18n.t('of.n')
    accreditation_i18n = I18n.t('activerecord.models.accreditation').capitalize
    start_i18n = I18n.t('start')
    accr_info = accreditation_i18n + ' ' + kind_i18n + ' ' + accreditation.kind \
    + ' [' + accreditation.id.to_s + '] ' + start_i18n + ' ' + I18n.l(accreditation.start)
    expect(accr_info).to eq accreditation.info
  end

  it 'can be created (for program)' do
    print I18n.t('activerecord.models.accreditation').capitalize + ': '

    FactoryBot.create(:accreditation, :program)
  end

  it 'can be created (for institution)' do
    print I18n.t('activerecord.models.accreditation').capitalize + ': '

    FactoryBot.create(:accreditation, :institution)
  end

  it '-kind' do
    object_kind = ''

    object_kind += I18n.t('activerecord.models.program') if accreditation.program?

    object_kind += I18n.t('activerecord.models.institution') if accreditation.institutional?

    object_kind += I18n.t('activerecord.models.registration') if accreditation.registration?

    expect(object_kind).to eq(accreditation.kind)
  end

  context 'development-schoolyears' do
    context 'class methods' do
      # Confirmation pending - Entered by local administrators
      it '#pending' do
        pending_accreditations = Accreditation.where.not(id: Accreditation.confirmed)
        expect(pending_accreditations).to eq(Accreditation.pending)
      end

      # Entered or confirmed by managers (or eventually admin)
      it '#confirmed' do
        confirmed_accreditations = Accreditation.where(confirmed: true)
        expect(confirmed_accreditations).to eq(Accreditation.confirmed)
      end
    end

    context 'instance methods' do
      it '-confirmed?' do
        is_accreditation_confirmed = accreditation.confirmed
        expect(is_accreditation_confirmed).to eq(accreditation.confirmed?)
      end

      it '-pending?' do
        is_accreditation_pending = !accreditation.confirmed
        expect(is_accreditation_pending).to eq(accreditation.pending?)
      end

      it '-institutional?' do
        is_accreditation_institutional = accreditation.institution_id.present?
        expect(is_accreditation_institutional).to eq(accreditation.institutional?)
      end

      it '-program?' do
        is_accreditation_program = accreditation.program_id.present?
        expect(is_accreditation_program).to eq(accreditation.program?)
      end

      it '-registration?' do
        is_accreditation_registration = accreditation.registration_id.present?
        expect(is_accreditation_registration).to eq(accreditation.registration?)
      end
    end
  end
end

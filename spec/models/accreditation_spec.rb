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

  # Set to special for testing purposes to avoid "processing date not available message"
  let!(:payroll) { FactoryBot.create(:payroll, :personal_taxation, :special) }

  let!(:bankpayment) { FactoryBot.create(:bankpayment) }

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

      it '#cancelled_on_this_payroll(payroll)' do
        accreditations_cancelled_on_this_payroll = Accreditation
                                                   .where('revocation >= ? and revocation <= ?',
                                                          payroll.start, payroll.finish)
        expect(accreditations_cancelled_on_this_payroll)
          .to eq(Accreditation.cancelled_on_this_payroll(payroll))
      end

      it '#latest_completed_payroll_finish_date' do
        bankpayments_processed = Bankpayment.done # completed, done

        if bankpayments_processed.present?
          latest_bankpayments_processed = bankpayments_processed.latest

          if latest_bankpayments_processed.present?
            processed_bankpayments_latest_payroll_finish_dt = \
              Dateutils.to_gregorian(latest_bankpayments_processed.payroll.dayfinished)
          end
        end

        expect(processed_bankpayments_latest_payroll_finish_dt)
          .to eq Accreditation.latest_completed_payroll_finish_date
      end

      it '#suspended_on_this_payroll(payroll)' do
        accreditations_suspended_on_this_payroll = Accreditation
                                                   .where('suspension >= ? and suspension <= ?',
                                                          payroll.start, payroll.finish)
        expect(accreditations_suspended_on_this_payroll).to eq(Accreditation
          .suspended_on_this_payroll(payroll))
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

      it '-details_on_file?' do
        are_details_on_file = (accreditation.original || accreditation.renewed \
           || accreditation.suspended || accreditation.revoked)
        expect(are_details_on_file).to eq(accreditation.details_on_file?)
      end

      it '-cancelled_on_this_payroll?(payroll)' do
        revocation = accreditation.revocation
        status = if revocation.present?
                   (revocation >= payroll.start && revocation <= payroll.finish)
                 else
                   false
                 end

        expect(status).to eq(accreditation.cancelled_on_this_payroll?(payroll))
      end

      it '-suspended_on_this_payroll?(payroll)' do
        suspension = accreditation.suspension
        status = if suspension.present?
                   (suspension >= payroll.start && suspension <= payroll.finish)
                 else
                   false
                 end

        expect(status).to eq(accreditation.suspended_on_this_payroll?(payroll))
      end

      it '-renewed_on_this_payroll?(payroll)' do
        renewed = accreditation.renewed
        status = if renewed.present?
                   (renewal >= payroll.start && renewal <= payroll.finish)
                 else
                   false
                 end

        expect(status).to eq(accreditation.suspended_on_this_payroll?(payroll))
      end
    end
  end
end

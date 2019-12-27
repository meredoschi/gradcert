# frozen_string_literal: true

require 'rails_helper'

include ActionView::Helpers::NumberHelper
include ActionView::Helpers::TextHelper

RSpec.describe Annotation, type: :model do
  let(:registration) { Registration.contextual_today.active.last }
  let(:payroll) { Payroll.last }
  let(:annotation) do
    FactoryBot.create(:annotation, registration_id: registration.id,
                                   payroll_id: payroll.id)
  end

  it 'can be created' do
    # replaced by let above

    #  registration=Registration.contextual_today.active.last
    #  payroll=Payroll.last
    #  annotation = FactoryBot.create(:annotation, registration_id: registration.id,
    #               payroll_id: payroll.id)

    print I18n.t('activerecord.models.annotation').capitalize + ': '
    puts annotation.detailed
  end

  it '-payroll_name' do
    annotation_payroll_name = annotation.payroll.name
    expect(annotation_payroll_name).to eq(annotation.payroll_name)
  end

  it '-impact' do
    annotation_impact = annotation.impact
    expect(annotation_impact).to eq(annotation.impact)
  end

  it '-kind' do
    @annotation_kind = I18n.t('activerecord.attributes.annotation.virtual.kind') + ': '

    @annotation_kind += if annotation.automatic?

                          I18n.t('activerecord.attributes.annotation.automatic').downcase

                        else

                          I18n.t('activerecord.attributes.annotation.virtual.manual').downcase

                        end

    expect(@annotation_kind).to eq(annotation.kind)
  end

  it '-absencesinfo' do
    annotation_absences_info = ''

    absences_i18n = I18n.t('activerecord.attributes.event.absence')
    skip_i18n = I18n.t('activerecord.attributes.annotations.skip')

    if annotation.absences.present? && annotation.absences > 0
      annotation_absences_info = pluralize(annotation.absences, I18n.t('absences_i18n')).downcase

      annotation_absences_info += ' - ' + skip_i18n if annotation.skip?

    else
      annotation_absences_info = I18n.t('no_absences').capitalize
    end

    expect(annotation_absences_info).to eq(annotation.absencesinfo)
  end
  it '-impactdetails' do
    annotation.supplement = 700
    annotation.discount = 900

    impact_amount = helper.number_to_currency(annotation.impact)
    supplement_amount = helper.number_to_currency(annotation.supplement)
    discount_amount = helper.number_to_currency(annotation.discount)

    annotation_impact_details = I18n.t('discounts_and_supplements').capitalize + '-> '

    annotation_impact_details += I18n.t('activerecord.attributes.annotation.
      virtual.impact') + ': ' + impact_amount

    annotation_impact_details += ' (' + I18n.t('negative') + ')' if annotation.impact < 0

    annotation_impact_details += +' [' + I18n.t('activerecord.attributes.annotation.
      supplement') + ': ' + supplement_amount
    annotation_impact_details += +' ; ' + I18n.t('activerecord.attributes.annotation.
      discount') + ': ' + discount_amount + ']'

    expect(annotation_impact_details).to eq(annotation.impactdetails)

    puts annotation.impactdetails
  end

  it 'discount or supplement may not be negative' do
    annotation_attempt = FactoryBot.build(:annotation, registration_id: registration.id,
                                                       payroll_id: payroll.id,
                                                       discount: -400, supplement: -300)

    expect(annotation_attempt).to be_invalid
  end

  it 'supplement may not be too big' do
    # too big > 11 months (extreme case)

    # To do: define -> Scholarship - contextual today

    scholarship = Scholarship.active.first

    puts scholarship.detailed

    annotation_attempt = FactoryBot.build(:annotation, registration_id: registration.id,
                                                       payroll_id: payroll.id, supplement: 100_300)

    expect(annotation_attempt).to be_invalid
  end

  it 'supplement may not be too big' do
    # too big > 11 months (extreme case)

    # To do: define -> Scholarship - contextual today

    scholarship = Scholarship.active.first

    puts scholarship.detailed

    annotation_attempt = FactoryBot.build(:annotation, registration_id: registration.id,
                                                       payroll_id: payroll.id, supplement: 100_300)

    expect(annotation_attempt).to be_invalid
  end

  it '-fulldetails' do
    annotation_full_details = annotation.detailed + ' [' + annotation.kind + \
                              '] ' + annotation.absencesinfo + ' - ' + annotation.impactdetails

    expect(annotation_full_details).to eq annotation.fulldetails
  end

  it '-info' do
    annotation_info = ' [' + annotation.kind + '] ' + annotation.absencesinfo + \
                      ' - ' + annotation.impactdetails
    expect(annotation_info).to eq annotation.info
  end
end

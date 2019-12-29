# frozen_string_literal: true

require 'rails_helper'

describe PayrollsHelper, type: :helper do
  include MoneyRails::ActionViewExtension

  let!(:payroll) { FactoryBot.create(:payroll, :personal_taxation) }
  let!(:taxation) { FactoryBot.create(:taxation, :personal) }
  let!(:scholarship) { FactoryBot.create(:scholarship, :pap, finish: '2050-1-1') }

  let(:dt) { Time.zone.today - 60 }

  it '-warn_if_special(payroll)' do
    txt = ''

    txt = I18n.t('activerecord.attributes.payroll.special') if payroll.special?
    safe_txt = safe_join([txt])

    expect(safe_txt).to eq(helper.warn_if_special(payroll))
  end

  it '-display_payment_amount(payroll)' do
    scholarship_amount = Scholarship.in_effect_for(payroll).first.amount

    txt = if payroll.special?

            I18n.t('activerecord.attributes.payroll.special') + ': ' \
              +humanized_money_with_symbol(scholarship_amount)

          else

            humanized_money(scholarship_amount)

          end

    safe_txt = safe_join([txt])
    expect(safe_txt).to eq(helper.display_payment_amount(payroll))
  end
end

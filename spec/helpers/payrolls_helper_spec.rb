# frozen_string_literal: true

require 'rails_helper'

describe PayrollsHelper, type: :helper do
  let!(:payroll) { FactoryBot.create(:payroll, :personal_taxation, :special) }
  let!(:taxation) { FactoryBot.create(:taxation, :personal) }
  let!(:scholarship) { FactoryBot.create(:scholarship, :pap, finish: '2050-1-1') }

  let(:dt) { Time.zone.today - 60 }

  it 'warn_if_special(payroll)' do
    txt = ''

    txt += ta('payroll.special') if payroll.special?
    safe_txt = safe_join(txt)

    expect(safe_txt).to eq(helper.warn_if_special(payroll))
  end

  it 'display_payment_amount(payroll)' do
    scholarship_amount = Scholarship.in_effect_for(payroll).first.amount

    # scholarships=Scholarship.where("? >= start and ? <= finish ",p.monthworked, p.monthworked)

    # puts scholarships.first

    prefix = ''

    prefix = I18n.t('activerecord.attributes.payroll.special') + ': ' if payroll.special?

    txt = prefix + humanized_money(scholarship_amount)

    safe_txt = safe_join(txt)

    expect(safe_txt).to eq(helper.display_payment_amount(payroll))
  end

  #
  #   def compute_total_absences(registration)
  #
  #         @annotations.absences_for(registration)
  #
  #   end
  #
  #   def display_payment_amount(payroll)
  #
  #       scholarship_amount=Scholarship.in_effect_for(payroll).first.amount
  #
  #       if payroll.special?
  #
  #         txt=I18n.t('activerecord.attributes.payroll.special')+': ' \
  #         +humanized_money_with_symbol(payroll.amount)
  #
  #       else
  #
  #         txt=humanized_money(scholarship_amount)
  #
  #       end
  #
  #       return txt.html_safe
  #
  #   end
  #
  #   def display_amount_if_regular(payroll)
  #
  #       txt=''
  #
  #       if payroll.regular?
  #
  #         txt=humanized_money(payroll.scholarship.amount)
  #
  #       else
  #
  #         txt='---'
  #
  #       end
  #
  #       return txt.html_safe
  #
  #   end
  #
  #   def display_amount_if_special(payroll)
  #
  #       txt=''
  #
  #       if payroll.special?
  #
  #         txt=humanized_money_with_symbol(payroll.amount)
  #
  #       else
  #
  #         txt='---'
  #
  #       end
  #
  #       return txt.html_safe
  #
  #   end
  #
end

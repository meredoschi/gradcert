# frozen_string_literal: true

# Revised December 2019
module PayrollsHelper
  # https://apidock.com/rails/v4.2.1/ActionView/Helpers/OutputSafetyHelper/safe_join
  def warn_if_special(payroll)
    txt = ''

    txt = I18n.t('activerecord.attributes.payroll.special') if payroll.special?

    safe_join([txt])
  end

  def display_payment_amount(payroll)
    scholarship_amount = Scholarship.in_effect_for(payroll).first.amount

    txt = if payroll.special?

            I18n.t('activerecord.attributes.payroll.special') + ': ' \
                 +humanized_money_with_symbol(scholarship_amount)

          else

            humanized_money(scholarship_amount)

          end

    safe_join([txt])
  end
end

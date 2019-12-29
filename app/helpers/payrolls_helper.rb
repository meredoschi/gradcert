module PayrollsHelper


	def warn_if_special(payroll)

		txt=''

		if payroll.special?

				txt+=ta('payroll.special')
		end

		return txt.html_safe

	end


	def compute_total_absences(registration)

        @annotations.absences_for(registration)

	end


	def display_payment_amount(payroll)


			scholarship_amount=Scholarship.in_effect_for(payroll).first.amount

      prefix=''

 			if payroll.special?

				prefix=I18n.t('activerecord.attributes.payroll.special')+': '

  		end

				prefix+humanized_money(scholarship_amount).html_safe

	end

	def display_amount_if_regular(payroll)

			txt=''

			if payroll.regular?

				txt=humanized_money(payroll.scholarship.amount)

			else

				txt='---'

			end

			return txt.html_safe

	end

	def display_amount_if_special(payroll)

			txt=''

			if payroll.special?

				txt=humanized_money_with_symbol(payroll.amount)

			else

				txt='---'

			end

			return txt.html_safe

	end


end

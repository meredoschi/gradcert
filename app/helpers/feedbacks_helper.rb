module FeedbacksHelper

	# A supplemental remittance - very rare occurrence
	def supplemental_remittance?

			return @feedback.special_payroll?

	end

	def display_date_processed(feedback)

			if feedback.processed? && feedback.processingdate.present?

		  	txt=I18n.l(feedback.processingdate, format: :compact)

				return txt.html_safe

			else

				return '-'.html_safe

			end

	end

	# Most commmon situation
	def regular_feedback?

			return !supplemental_remittance?

	end

	# Payment was confirmed by the bank
	def processed?

			return @feedback.processed?

	end

	def pending?

			return !@feedback.processed?

	end


end

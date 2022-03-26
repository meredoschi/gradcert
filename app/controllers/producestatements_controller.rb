class ProducestatementsController < ApplicationController

  before_action :authenticate_user! # By default... Devise

  def show

    set_calculation_variables

    @bankpayment = Bankpayment.find(params[:bankpayment_id])

    @title=t('navbar.financial').upcase+' | '+t('activerecord.models.bankpayment').capitalize+' | '+t('generate')+' '+tm('statement').pluralize.capitalize

    @payroll=@bankpayment.payroll

    calculate_payroll(@bankpayment)

    if @bankpayment.resend?

      @feedbacks_with_confirmed_payments=Feedback.where(bankpayment_id: @bankpayment.id, processed: true, approved: true)

      @registration_ids_with_confirmed_payments=@feedbacks_with_confirmed_payments.pluck(:registration_id).uniq

      @registrations_with_confirmed_payments=Registration.where(id: @registration_ids_with_confirmed_payments)

    else

      @registrations_with_confirmed_payments=@confirmedregistrations

    end

    @registrations_with_confirmed_payments.ordered_by_contact_name.each_with_index do |registration, n|

      gross_amount=gross_payment_due(registration)

      adjustments=calculate_adjustments(registration)

      gross_amount+=adjustments # Discounts or Suplements

      social_security_fee=Taxes.social_security(@bankpayment, gross_amount)

      income_tax_due=Taxes.personal_income(@brackets, gross_amount, social_security_fee) # social security paid counts as a deduction

      net_payment=(gross_amount-social_security_fee-income_tax_due)

      # Hotfix
      unless  Statement.for_registration_on_bankpayment(registration,@bankpayment).exists?
           statement=Statement.create! registration_id: registration.id, bankpayment_id: @bankpayment.id, grossamount: gross_amount, incometax: income_tax_due, socialsecurity: social_security_fee, netamount: net_payment, childsupport: 0
      end

    end

    @num_statements=@all_statements.for_bankpayment(@bankpayment).count

  end

  private

  def calculate_absence_penalty(annotation, monthsize, payment)

				if !annotation.assiduous?


					return ((payment/monthsize)*annotation.absences)

	 	  	else

	   		return 0

	    	end

	end

  def calculate_adjustments(registration)

    	annotation=Annotation.for_registration_on_payroll(registration,@bankpayment.payroll).first

  #    annotation=Annotation.for_registration_on_payroll(registration,@actual_payroll).first (reworked?)

			if annotation.present? && annotation.supplement.present? && annotation.discount.present?

				 		impact=annotation.supplement-annotation.discount

			else

					impact=0

			end

		return impact

	end

  def gross_payment_due(registration)

      # quickfix

			payment=set_payment_amount

      @payroll=@bankpayment.payroll

      monthsize=days_for_month(@payroll.monthworked)

#			if	Annotation.exists_for_registration_on_payroll?(registration,@bankpayment.payroll)

      if	@all_annotations.exists_for_registration_on_payroll?(registration,@payroll)

			#			annotation=Annotation.for_registration_on_payroll(registration,@bankpayment.payroll).first

            annotation=@all_annotations.for_registration_on_payroll(registration,@payroll).first

				# Debug


        #byebug

				absence_penalty=calculate_absence_penalty(annotation, monthsize, payment)


				payment-=absence_penalty

				if annotation.skip?

						payment=0

				end

			end

			return payment

	end

  def social_security_tax(payment)

      taxation=@bankpayment.payroll.taxation

      taxes=payment*taxation.socialsecurity

      taxes=taxes/100.to_i

      return taxes

  end

  def set_payment_amount

	    payment=Scholarship.in_effect_for(@bankpayment.payroll).first.amount

		    return payment

	end

  def set_calculation_variables

    @all_annotations=Annotation.all
    @all_brackets=Bracket.all
    @all_feedbacks=Feedback.all
    @all_registrations=Registration.all
    @all_schoolarships=Scholarship.all
    @all_schoolterms=Schoolterm.all
    @all_statements=Statement.all

  end

  def calculate_payroll(bankpayment)

    set_calculation_variables

    @p=bankpayment.payroll

#    @registrations_in_context=Registration.contextual_on(@p.monthworked) # new for 2017

    @registrations_in_context=@all_registrations.contextual_on(@p.monthworked) # new for 2017

    # New for 2017
#    @p_schoolterm=Schoolterm.for_payroll(@p)

    @p_schoolterm=@all_schoolterms.for_payroll(@p)

    if bankpayment.resend?

#			@registration_ids_with_feedback=Feedback.pending.registration_ids_for_bankpayment(bankpayment)
# Hotfix
      @registration_ids_with_feedback=@all_feedbacks.registration_ids_for_bankpayment(bankpayment)

      @registrations=@registrations_in_context.accessible_by(current_ability).where(id: @registration_ids_with_feedback)

#      @p=Payroll.where(monthworked: @bankpayment.payroll.monthworked).regular.first


       @num_returned_payments=@registrations.count

    else

       @registrations=@registrations_in_context.accessible_by(current_ability)


    end


#    @p_annotations=Annotation.accessible_by(current_ability).for_payroll(@p).ordered_by_contact_name

    @p_annotations=@all_annotations.accessible_by(current_ability).for_payroll(@p).ordered_by_contact_name

    @normal=@registrations.regular_for_payroll(@p)
    @cancelled=@registrations.cancelled_on_this_payroll(@p)
    @suspended=@registrations.suspended_on_this_payroll(@p)
    @renewed=@registrations.renewed_on_this_payroll(@p)

    @possible_ids=@normal

    @possible=@registrations.where(id: @possible_ids)

    @num_normal=@normal.count
    @num_cancelled=@cancelled.count
    @num_suspended=@suspended.count
    @num_renewed=@renewed.count

    @num_possible=@possible.count

    @num_payroll_annotations=@p_annotations.count

    @adjustments=@p_annotations.adjustment

    @num_adjustments=@adjustments.count

    @skip_payment=@registrations.skipped_students_for_payroll(@p)

    @skip_payment_ids=@skip_payment.pluck(:id)

    @num_skip_payment=@skip_payment.count

    @regular_annotations=@p_annotations.regular

    @num_regular_annotations=@regular_annotations.count

    @present_annotations=@regular_annotations.automatic.frequent # Filter manual annotations

    @num_present_annotations=@present_annotations.count

    @absent_annotations=@regular_annotations.absent

    @num_absent_annotations=@absent_annotations.count

    @num_regular_annotations=@regular_annotations.count

    @confirmedregistrations=@possible.where.not(id: @skip_payment_ids)

    @num_confirmed_for_payment=@confirmedregistrations.count

#    @brackets=Bracket.for_taxation(bankpayment.payroll.taxation)

    @brackets=@all_brackets.for_taxation(bankpayment.payroll.taxation)

    @regular_payment=set_payment_amount  # Regular payment amount for the payroll (i.e. for most people)

  end



end

class PayrollcalculationController < ApplicationController

  before_action :set_variables, only: [:show]

  def clear

    @payroll = Payroll.find(params[:payroll_id])

    @payroll_annotations=Annotation.automatic.for_payroll(@payroll)

  	@payroll_annotations.delete_all

  	@residual_events=Event.for_payroll(@payroll).residual

  	@residual_events.delete_all

    # -------------------------------------
    @payroll.update(annotated: false)
    # -------------------------------------

    redirect_to controller: 'annotationreports', action: 'show', payroll_id: @payroll.id

  end

  def show

    @payroll = Payroll.find(params[:payroll_id])

    if @payroll.annotated?

      clear

    end

    if @payroll.regular?

      #      calculate_regular_payroll.delay # use delayed job to process it on the background

      regular

    else

      special

    end

    redirect_to controller: 'annotationreports', action: 'show', payroll_id: @payroll.id

  end

  private

  # Set days since application's Epoch

# According to the Event Type.

  # For the entire payroll cycle (e.g. month)

  def totally_absent?(days_in_payroll_cycle, num_days_absent)

    return num_days_absent>=days_in_payroll_cycle # defensive programming, could have been equal.

  end

  # Set calculation variables
  def set_variables

    @all_annotations=Annotation.all
    @all_events=Event.all
    @all_registrations=Registration.all

  end

  def calculate_absence_penalty(event, absences)

    if event.limited_leave?

      if absences>=event.leavetype.dayswithpaylimit

        if (event.finish.beginning_of_month-event.start.beginning_of_month > 0)

          offset=(event.start.beginning_of_month.next_month-event.start).to_i # i.e. deducted days already "enjoyed" on the previous month

        end


        return (absences-offset)-(leavetype.dayswithpaylimit-offset)

      else

        return 0

      end

    else

      if event.paid_leave?

        return 0

      else

        return absences

      end

    end

  end

  def regular

    @registrations=@all_registrations.contextual_on(@payroll.start) # Works for March as well (references february)

    @payroll_interval=(@payroll.daystarted..@payroll.dayfinished)

    @cancelled_registrations=@registrations.cancelled_during_payroll(@payroll)

    @cancelled_registrations.each do |registration|

      accreditation=registration.accreditation

      if accreditation.confirmed?

        confirmation_status=true

      else

        confirmation_status=false

      end

      # Insufficient number of days worked in order to generate the first payment
      if registration.early_cancellation?

        #    if Annotation.exists_for_registration_on_payroll?(registration,@payroll)
        if @all_annotations.exists_for_registration_on_payroll?(registration,@payroll)

          annotation=registration.annotation.first # It is assumed there is only one.

          days_worked=registration.num_days_worked_before_cancelling

          txt=I18n.t('early_cancellation').capitalize+' '
          txt+=I18n.l(registration.accreditation.revocation, format: :compact)+' '
          txt+=I18n.t('nothing_due').downcase


          annotation.update(comment: txt, skip: true)

        else

          #    	    annotation=Annotation.create! registration_id: registration.id, skip:true, payroll_id: @payroll.id, comment: I18n.t('early_cancellation').capitalize+': '+I18n.l(registration.accreditation.revocation), supplement_cents: 0, discount_cents: 0, confirmed: confirmation_status

          annotation=Annotation.create! registration_id: registration.id, skip:true, payroll_id: @payroll.id, comment: I18n.t('early_cancellation').capitalize+': '+I18n.l(registration.accreditation.revocation), supplement_cents: 0, discount_cents: 0, confirmed: confirmation_status

        end

      else

        #	       event=Event.create! registration_id: registration.id, residual: true, start: registration.accreditation.revocation, daystarted: (registration.accreditation.revocation-Settings.dayone).to_i, finish: @payroll.monthworked.end_of_month, dayfinished: (@payroll.monthworked.end_of_month-Settings.dayone).to_i, absence:true, confirmed: confirmation_status


          event=Event.create! registration_id: registration.id, residual: true, start: registration.accreditation.revocation, daystarted: (registration.accreditation.revocation-Settings.dayone).to_i, finish: @payroll.monthworked.end_of_month, dayfinished: (@payroll.monthworked.end_of_month-Settings.dayone).to_i, absence:true, confirmed: confirmation_status

      end

    end

    @suspended_registrations=@registrations.suspended_during_payroll(@payroll)

    @suspended_registrations.each do |suspended_registration, k|

      #     	event=Event.create! registration_id: suspended_registration.id, residual: true, start: suspended_registration.accreditation.suspension, daystarted: (suspended_registration.accreditation.suspension-Settings.dayone).to_i, finish: @payroll.monthworked.end_of_month, dayfinished: (@payroll.monthworked.end_of_month-Settings.dayone).to_i, absence:true
      #    	event=Event.create! registration_id: suspended_registration.id, residual: true, start: suspended_registration.accreditation.suspension, daystarted: (suspended_registration.accreditation.suspension-Settings.dayone).to_i, finish: @payroll.monthworked.end_of_month, dayfinished: (@payroll.monthworked.end_of_month-Settings.dayone).to_i, absence:true, confirmed: true
      event=Event.create! registration_id: suspended_registration.id, residual: true, start: suspended_registration.accreditation.suspension, daystarted: (suspended_registration.accreditation.suspension-Settings.dayone).to_i, finish: @payroll.monthworked.end_of_month, dayfinished: (@payroll.monthworked.end_of_month-Settings.dayone).to_i, absence:true, confirmed: true

    end

    # -----------------------------------------------------------------------------------------------

    @late_registrations=@registrations.late_during_payroll(@payroll)

    @late_registrations.each do |registration, k|

      # monthwork = reference month = 1st day of the month
      first_of_month=@payroll.monthworked.beginning_of_month
      eve_of_registration=registration.accreditation.start-1

      #			event=Event.create! registration_id: registration.id, residual: true, start: first_of_month , daystarted: to_numeric_date(first_of_month), finish: eve_of_registration, dayfinished: to_numeric_date(eve_of_registration), absence:true
      #			event=Event.create! registration_id: registration.id, residual: true, start: first_of_month , daystarted: to_numeric_date(first_of_month), finish: eve_of_registration, dayfinished: to_numeric_date(eve_of_registration), absence:true, confirmed: true

      event=Event.create! registration_id: registration.id, residual: true, start: first_of_month , daystarted: to_numeric_date(first_of_month), finish: eve_of_registration, dayfinished: to_numeric_date(eve_of_registration), absence:true, confirmed: true

    end

    @renewed_registrations=@registrations.renewed_during_payroll(@payroll)

    @renewed_registrations.each do |registration, k|

      @renewal_date=registration.accreditation.renewal

      first_of_month=@payroll.monthworked.beginning_of_month
      eve_of_renewal=registration.accreditation.start-1

      if first_of_month?(@renewal_date)

        @remark=I18n.t('activerecord.registration.accreditation.renewal')+' '+I18n.l(@renewal_date , :format => :dmy)

        #       Confirmed attribute on annotations deprecated, placed on events
        #				annotation=Annotation.create! registration_id: registration.id, skip:false, payroll_id: @payroll.id, absences: 0, confirmed: true, supplement_cents: 0, discount_cents: 0, comment: @remark

        #				annotation=Annotation.create! registration_id: registration.id, skip:false, payroll_id: @payroll.id, absences: 0, supplement_cents: 0, discount_cents: 0, comment: @remark
        annotation=Annotation.create! registration_id: registration.id, skip:false, payroll_id: @payroll.id, absences: 0, supplement_cents: 0, discount_cents: 0, comment: @remark

        # Create event normally
      else

        # 				event=Event.create! registration_id: registration.id, residual: true, start: first_of_month , daystarted: to_numeric_date(first_of_month), finish: eve_of_renewal, dayfinished: to_numeric_date(eve_of_renewal), absence:true

        #       Added confirmed attribute for events

        #				event=Event.create! registration_id: registration.id, residual: true, start: first_of_month , daystarted: to_numeric_date(first_of_month), finish: eve_of_renewal, dayfinished: to_numeric_date(eve_of_renewal), absence:true, confirmed: true
        event=Event.create! registration_id: registration.id, residual: true, start: first_of_month , daystarted: to_numeric_date(first_of_month), finish: eve_of_renewal, dayfinished: to_numeric_date(eve_of_renewal), absence:true, confirmed: true

      end

    end

    #     payroll_events=Event.for_payroll(@payroll)

    #    payroll_events=Event.confirmed.for_payroll(@payroll) # Added filter for confirmed events only

    #    payroll_events=Event.confirmed.for_payroll(@payroll).contextual_on(@payroll.monthworked) # Added context

    payroll_events=@all_events.confirmed.for_payroll(@payroll).contextual_on(@payroll.monthworked) # Added context

    #		registration_ids_with_events=Event.registration_ids_for_payroll(@payroll)

    registration_ids_with_events=@all_events.registration_ids_for_payroll(@payroll)

    registration_ids_with_events.each_with_index do |r_id, i|

      #			r=Registration.find(r_id)

      r=@all_registrations.find(r_id)

      registration_events=payroll_events.for_registration(r)

      student_unpaid_absences=0
      total_num_days=0

      registration_events.each_with_index do |e, j|

        num_days=Logic::intersection_size(e.interval,@payroll_interval)
        student_unpaid_absences+=calculate_absence_penalty(e, num_days)
        total_num_days+=num_days

      end

      #		if Annotation.exists_for_registration_on_payroll?(r,@payroll)

      if @all_annotations.exists_for_registration_on_payroll?(r,@payroll)

        #    	   annotation=Annotation.for_registration_on_payroll(r,@payroll).first

        annotation=@all_annotations.for_registration_on_payroll(r,@payroll).first

        #     	   Annotation.update(annotation.id, skip:false, payroll_id: @payroll.id, absences: student_unpaid_absences, confirmed: true, automatic: false)
        #      	   Annotation.update(annotation.id, skip:false, payroll_id: @payroll.id, absences: student_unpaid_absences, automatic: false)

        #           @all_annotations.update(annotation.id, skip:false, payroll_id: @payroll.id, absences: student_unpaid_absences, automatic: false)
        Annotation.update(annotation.id, payroll_id: @payroll.id, absences: student_unpaid_absences, automatic: false)


      else

        #     	   annotation=Annotation.create! registration_id: r.id, automatic:true, skip:false, payroll_id: @payroll.id, absences: student_unpaid_absences, confirmed: true, supplement_cents: 0, discount_cents: 0

        # 	    	   annotation=Annotation.create! registration_id: r.id, automatic:true, skip:false, payroll_id: @payroll.id, absences: student_unpaid_absences, supplement_cents: 0, discount_cents: 0

        #           annotation=@all_annotations.create! registration_id: r.id, automatic:true, skip:false, payroll_id: @payroll.id, absences: student_unpaid_absences, supplement_cents: 0, discount_cents: 0

        annotation=Annotation.create! registration_id: r.id, automatic:true, payroll_id: @payroll.id, absences: student_unpaid_absences, supplement_cents: 0, discount_cents: 0

      end

      if totally_absent?(@payroll_interval.size, student_unpaid_absences)

        annotation.update(skip: true)

      end

    end

    # -------------------------------------
    @payroll.update(annotated: true)
    # -------------------------------------

  end

  def special

    feedback_reg_ids=Feedback.for_payroll(@payroll).pluck(:registration_id) # Get registration ids from feedbacks

		@registrations=Registration.where(id: feedback_reg_ids)

		dstart=(@payroll.monthworked.beginning_of_month-Settings.dayone).to_i
		dfinish=(@payroll.monthworked.end_of_month-Settings.dayone).to_i

   	@payroll_interval=(dstart..dfinish) #

		# Get events, based on reference month rather than payroll_id

    payroll_events=Event.on_month(@payroll.monthworked).contextual_on(@payroll.monthworked) # Added context

		registration_ids_with_events=payroll_events.where(registration_id: @registrations)

    registration_ids_with_events.each_with_index do |r_id, i|

			r=Registration.find(r_id)

				registration_events=payroll_events.for_registration(r)

			  student_unpaid_absences=0
			  total_num_days=0

	  		registration_events.each_with_index do |e, j|

					num_days=Logic::intersection_size(e.interval,@payroll_interval)
					student_unpaid_absences+=calculate_absence_penalty(e, num_days)
					total_num_days+=num_days

				end

				if Annotation.exists_for_registration_on_payroll?(r,@payroll)

    	   annotation=Annotation.for_registration_on_payroll(r,@payroll).first

    	   Annotation.update(annotation.id, skip:false, payroll_id: @payroll.id, absences: student_unpaid_absences, confirmed: true, automatic: false)

         Annotation.update(annotation.id, payroll_id: @payroll.id, absences: student_unpaid_absences, confirmed: true, automatic: false)

 				else

#    	   annotation=Annotation.create! registration_id: r.id, automatic:true, skip:false, payroll_id: @payroll.id, absences: student_unpaid_absences, confirmed: true, supplement_cents: 0, discount_cents: 0

         annotation=Annotation.create! registration_id: r.id, automatic:true, payroll_id: @payroll.id, absences: student_unpaid_absences, confirmed: true, supplement_cents: 0, discount_cents: 0

 				end

    # Hotfix, temporarily disabled
 		#		if totally_absent?(@payroll_interval.size, student_unpaid_absences)

		#			annotation.update(skip: true)

		#		end

  	end

      # -------------------------------------
      @payroll.update(annotated: true)
      # -------------------------------------

  end

end
